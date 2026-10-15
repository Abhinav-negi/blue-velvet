import 'dart:convert';

import 'organize_prompt.dart';

/// Op rules shared by buildProposal / reviseProposal / generateProject
/// (AI_CONTRACT 3, 4.5-4.7). [allowed] is the permission-filtered op list.
String _opRules(List<String> allowed) =>
    '''
You only propose CHANGE-OPS. The app applies them after the user approves; you never write project data.
Allowed ops (use no other): ${allowed.join(', ')}.
- Every op puts only facts the user said into the project. Never add ideas, plot points, traits, names or details. Never delete anything. Never write dialogue.
- addBeat: ref (short unique string like "b1"), title, description, character_names. Optional slot: copy slot_seed_id when the slot lists a seed_id, otherwise slot_id (never both), and position null.
- editBeat / moveBeat / placeBeatInSlot / addScaffold target a beat with beat_id (existing beat) or beat_ref (an earlier addBeat ref), never both. placeBeatInSlot is only for unplaced beats.
- splitBeat: beat_id and parts (2 or more, each title, description, character_names). mergeBeats: beat_ids (2 or more).
- addCharacter: name and fields (age, role, appearance, background, traits, habits, wants_needs_fears, notes; only what was said). editCharacter: project_character_id and fields holding the FULL new text (repeat the old text you keep, then add the new fact).
- setSummary: text = the existing project summary plus the new facts; never drop an existing fact.
- addScaffold: film projects use "blocks" (type scene_heading or action only, describing only what the user said); other projects use "rows" with say "" and show {a_roll, b_roll, on_screen_text, graphics}. Never dialogue, parentheticals, character cues or transitions.
- Prefer editBeat/editCharacter over duplicating an existing beat or character. Ops appear in application order; a beat_ref must come after its addBeat.
- Existing ids and slot ids come only from the INPUT. Unused fields are null.''';

const _summaryRules =
    '"summary_sentences": the user\'s new input as short cleaned sentences, '
    'each ONE sentence. For each, "source_quotes" are exact substrings copied '
    'character for character from the RAW_TRANSCRIPT (smallest supporting '
    'stretch). Never give offsets.';

String _grammar(bool g) => g
    ? 'GRAMMAR_CLEANUP: true (fix grammar)'
    : 'GRAMMAR_CLEANUP: false (remove filler, repeats and false starts and '
          'order the points, but do not correct grammar)';

String buildProposalPrompt(
  String raw,
  Map<String, dynamic> context,
  Map<String, dynamic> permissions,
  List<String> allowed,
  bool grammar,
) =>
    '$sharedRules\n\nTASK: turn the RAW_TRANSCRIPT into a proposal for this '
    'project: the clean summary of what the user said plus the smallest set '
    'of ops that puts exactly those facts into the project.\n'
    '$_summaryRules\n${_opRules(allowed)}\n\n${_grammar(grammar)}\n'
    'PERMISSIONS: ${jsonEncode(permissions)}\n'
    'PROJECT_CONTEXT: ${jsonEncode(context)}\n\nRAW_TRANSCRIPT:\n$raw';

String reviseProposalPrompt(
  Map<String, dynamic> proposal,
  String instruction,
  Map<String, dynamic> context,
  Map<String, dynamic> permissions,
  List<String> allowed,
  bool grammar,
) =>
    '$sharedRules\n\nTASK: revise the PROPOSAL according to the INSTRUCTION. '
    'Return the FULL replacement list of ops. Keep an existing op by giving '
    'its "id" (changed or not); an op without "id" is new; an existing op you '
    'leave out is removed. You may only remove, narrow, reshape or re-target '
    'facts the user already said (e.g. addBeat becomes editBeat). New facts '
    'are allowed only if the INSTRUCTION itself states them; quote those from '
    'the INSTRUCTION. The raw_transcript never changes.\n'
    '$_summaryRules\n${_opRules(allowed)}\n\n${_grammar(grammar)}\n'
    'PERMISSIONS: ${jsonEncode(permissions)}\n'
    'PROJECT_CONTEXT: ${jsonEncode(context)}\n'
    'PROPOSAL: ${jsonEncode(proposal)}\n\nINSTRUCTION:\n$instruction';

String generateProjectPrompt(
  String summary,
  String raw,
  String projectType,
  Map<String, dynamic>? template,
  Map<String, dynamic> permissions,
  List<String> allowed,
  bool grammar,
) =>
    '$sharedRules\n\nTASK: build the first content of a NEW project from the '
    'user\'s story idea. Use only the ops listed. "title" is only a title the '
    'user actually said, else null. Place beats into TEMPLATE slots only when '
    'the user\'s words clearly fit that slot; otherwise leave the beat '
    'unplaced. Storyboards stay empty.\n${_opRules(allowed)}\n\n'
    '${_grammar(grammar)}\nPROJECT_TYPE: $projectType\n'
    'PERMISSIONS: ${jsonEncode(permissions)}\n'
    'TEMPLATE: ${jsonEncode(template)}\n'
    'SUMMARY: $summary\n\nRAW_TRANSCRIPT:\n$raw';

String detectMentionPrompt(String raw, List<Map<String, dynamic>> projects) =>
    '$sharedRules\n\nTASK: decide whether the RAW_TRANSCRIPT names or clearly '
    'continues one of the PROJECTS (by title, a character, or its story). '
    'Return its id as project_id, a confidence from 0 to 1, and matched_phrase '
    '(exact words from the RAW_TRANSCRIPT that point at it). If none clearly '
    'matches, project_id is null. Never guess.\n\n'
    'PROJECTS: ${jsonEncode(projects)}\n\nRAW_TRANSCRIPT:\n$raw';
