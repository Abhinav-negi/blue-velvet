import 'dart:convert';

import 'ai_client.dart';
import 'errors.dart';
import 'permissions.dart';
import 'prompts/scaffold_prompts.dart';

/// Where one beat goes in the new template. Both slot fields null = unplaced.
class Placement {
  const Placement(this.beatId, this.slotSeedId, this.slotId, this.position);
  final String beatId;
  final String? slotSeedId;
  final String? slotId;
  final int position;
}

/// Validates AI_CONTRACT 9.1 #9: every input beat exactly once, slot ids exist
/// in the new template. Throws [FormatException]. Public for tests.
List<Placement> parsePlacements(
  Map<String, dynamic> json, {
  required List<String> beatIds,
  required Set<String> seedIds,
  required Set<String> slotIds,
}) {
  final raw = json['placements'];
  if (raw is! List) throw const FormatException('placements missing');
  final out = <Placement>[];
  for (final p in raw) {
    if (p is! Map || p['beat_id'] is! String || p['position'] is! int) {
      throw const FormatException('malformed placement');
    }
    final seed = p['slot_seed_id'] as String?;
    final slot = p['slot_id'] as String?;
    if (seed != null && slot != null) {
      throw const FormatException('both slot_seed_id and slot_id set');
    }
    if ((seed != null && !seedIds.contains(seed)) ||
        (slot != null && !slotIds.contains(slot))) {
      throw const FormatException('unknown slot id');
    }
    out.add(
      Placement(p['beat_id'] as String, seed, slot, p['position'] as int),
    );
  }
  final got = out.map((p) => p.beatId).toList()..sort();
  final want = [...beatIds]..sort();
  if (got.length != want.length ||
      !List.generate(got.length, (i) => got[i] == want[i]).every((e) => e)) {
    throw const FormatException('every input beat must appear exactly once');
  }
  return out;
}

/// Propose slot placement for [beats] in [newTemplate] (AI_CONTRACT 4.9).
/// Gate: auto_placement. [beats]: `{id, title, description,
/// current_slot_name}`; [newTemplate]: `{slots:[{slot_id, seed_id, name,
/// description, runtime_proportion}]}`. The caller turns placements into
/// `moveBeat` ops; nothing is written here.
Future<List<Placement>> remapTemplate(
  AiClient ai, {
  required List<Map<String, dynamic>> beats,
  required Map<String, dynamic> newTemplate,
  Map<String, dynamic> permissions = const {},
}) async {
  final slots = (newTemplate['slots'] as List).cast<Map<String, dynamic>>();
  final base =
      '$sharedRules\n\n$remapInstruction\n\n'
      'BEATS: ${jsonEncode(beats)}\nNEW_TEMPLATE: ${jsonEncode(newTemplate)}';
  var prompt = base;
  for (var attempt = 0; ; attempt++) {
    final json = await ai.generateJson(
      prompt: prompt,
      schema: remapSchema,
      gate: AiPermission.autoPlacement,
      permissions: permissions,
    );
    try {
      return parsePlacements(
        json,
        beatIds: [for (final b in beats) b['id'] as String],
        seedIds: {
          for (final s in slots)
            if (s['seed_id'] != null) s['seed_id'] as String,
        },
        slotIds: {
          for (final s in slots)
            if (s['slot_id'] != null) s['slot_id'] as String,
        },
      );
    } on FormatException catch (e) {
      if (attempt == 1) {
        throw AiMalformedResponse('Remap rejected: ${e.message}');
      }
      prompt =
          '$base\n\nYour last output broke the rules: ${e.message}. '
          'Fix it.';
    }
  }
}

/// One structure suggestion. Always a suggestion, never an op: the UI labels
/// it "AI suggestion" and stores nothing unless the user taps it.
class StructureSuggestion {
  const StructureSuggestion(this.label, this.idea);
  final String label;
  final String idea;
  bool get isSuggestion => true;
}

/// Structure ideas on explicit user request (AI_CONTRACT 4.10). No permission
/// gate; never run automatically.
Future<List<StructureSuggestion>> suggestStructure(
  AiClient ai, {
  required Map<String, dynamic> beat,
  required Map<String, dynamic> projectContext,
  required String question,
}) async {
  final json = await ai.generateJson(
    prompt:
        '$sharedRules\n\n$suggestInstruction\n\n'
        'BEAT: ${jsonEncode(beat)}\n'
        'PROJECT_CONTEXT: ${jsonEncode(projectContext)}\nQUESTION: $question',
    schema: suggestSchema,
  );
  final raw = json['suggestions'];
  if (raw is! List) {
    throw const AiMalformedResponse('suggestions missing');
  }
  return [
    for (final s in raw)
      if (s is Map && s['label'] is String && s['idea'] is String)
        StructureSuggestion(s['label'] as String, s['idea'] as String),
  ];
}
