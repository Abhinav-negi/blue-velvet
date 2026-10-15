// Validates a built-in library seed file against docs/SEED_SCHEMA.md.
// Usage: dart tool/validate_seed.dart <file.json>   (dart: libraries only)
// The schema is picked from the file name (templates.json, shots_camera.json, ...).
import 'dart:convert';
import 'dart:io';

const reservedTemplateIds = [
  'three-act', 'eight-sequence', 'save-the-cat', 'heros-journey',
  'five-point', 'story-circle', 'kishotenketsu',
];
const projectTypeIds = ['short-film', 'long-film', 'youtube-video', 'short'];
const licenses = ['PD', 'CC0', 'CC-BY', 'CC-BY-SA'];
const shotCategories = [
  'shot_size', 'angle', 'movement', 'composition', 'lens', 'lighting',
];
final slugRe = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$');

final errors = <String>[];
void err(String path, String msg) => errors.add('$path: $msg');

// ---- field helpers: each returns the value if valid, else records an error.
String? str(Map m, String k, String p, {bool req = true}) {
  final v = m[k];
  if (v == null) {
    if (req) err('$p.$k', 'required string is missing');
    return null;
  }
  if (v is! String || v.trim().isEmpty) {
    err('$p.$k', 'must be a non-empty string');
    return null;
  }
  return v;
}

num? number(Map m, String k, String p,
    {bool req = true, num? min, num? max, bool integer = false}) {
  final v = m[k];
  if (v == null) {
    if (req) err('$p.$k', 'required number is missing');
    return null;
  }
  if (v is! num || (integer && v is! int)) {
    err('$p.$k', 'must be ${integer ? 'an integer' : 'a number'}');
    return null;
  }
  if ((min != null && v < min) || (max != null && v > max)) {
    err('$p.$k', 'must be in range ${min ?? '-inf'}..${max ?? 'inf'}, got $v');
    return null;
  }
  return v;
}

String? oneOf(Map m, String k, String p, List<String> allowed,
    {bool req = true}) {
  final v = str(m, k, p, req: req);
  if (v != null && !allowed.contains(v)) {
    err('$p.$k', '"$v" is not one of ${allowed.join(', ')}');
    return null;
  }
  return v;
}

void slug(Object? v, String path) {
  if (v is! String || !slugRe.hasMatch(v)) {
    err(path, 'must be a kebab-case slug (a-z, 0-9, hyphens), got $v');
  }
}

List? list(Map m, String k, String p, {bool req = true, bool nonEmpty = false}) {
  final v = m[k];
  if (v == null) {
    if (req) err('$p.$k', 'required list is missing');
    return null;
  }
  if (v is! List) {
    err('$p.$k', 'must be a list');
    return null;
  }
  if (nonEmpty && v.isEmpty) err('$p.$k', 'must not be empty');
  return v;
}

void strList(Map m, String k, String p, {bool req = true, bool nonEmpty = false}) {
  final l = list(m, k, p, req: req, nonEmpty: nonEmpty);
  if (l == null) return;
  for (var i = 0; i < l.length; i++) {
    if (l[i] is! String || (l[i] as String).trim().isEmpty) {
      err('$p.$k[$i]', 'must be a non-empty string');
    }
  }
}

void urlList(Map m, String k, String p, {bool req = true}) {
  final l = list(m, k, p, req: req, nonEmpty: req);
  if (l == null) return;
  for (var i = 0; i < l.length; i++) {
    final v = l[i];
    if (v is! String || !RegExp(r'^https?://\S+$').hasMatch(v)) {
      err('$p.$k[$i]', 'must be an http(s) URL, got $v');
    }
  }
}

/// Runs [check] on each map in list [l]; `items[i]` paths.
void each(List? l, String p, void Function(Map m, String p) check) {
  if (l == null) return;
  for (var i = 0; i < l.length; i++) {
    final e = l[i];
    if (e is! Map) {
      err('$p[$i]', 'must be an object');
    } else {
      check(e, '$p[$i]');
    }
  }
}

// ---- per-file item checks. `ctx` carries file-level data.
typedef Check = void Function(Map m, String p, String dir);

void template(Map m, String p, String dir) {
  str(m, 'name', p);
  str(m, 'description', p);
  urlList(m, 'source_urls', p);
  final pts = list(m, 'project_types', p, nonEmpty: true);
  for (var i = 0; pts != null && i < pts.length; i++) {
    if (!projectTypeIds.contains(pts[i])) {
      err('$p.project_types[$i]', '"${pts[i]}" is not one of ${projectTypeIds.join(', ')}');
    }
  }
  final ids = <String>{};
  num total = 0;
  each(list(m, 'slots', p, nonEmpty: true), '$p.slots', (s, sp) {
    slug(s['id'], '$sp.id');
    if (s['id'] is String && !ids.add(s['id'] as String)) {
      err('$sp.id', 'duplicate slot id "${s['id']}"');
    }
    str(s, 'name', sp);
    str(s, 'description', sp);
    total += number(s, 'proportion', sp, req: false, min: 0, max: 1) ?? 0;
  });
  if (total > 1.001) err('$p.slots', 'proportions sum to $total, must be <= 1');
}

void shot(Map m, String p, String dir) {
  str(m, 'name', p);
  oneOf(m, 'category', p, shotCategories);
  str(m, 'description', p);
  str(m, 'when_to_use', p);
  str(m, 'effect', p);
  strList(m, 'tags', p);
  urlList(m, 'sources', p);
  each(list(m, 'images', p), '$p.images', (im, ip) {
    final f = str(im, 'file', ip);
    oneOf(im, 'license', ip, licenses);
    str(im, 'author', ip);
    urlList2(im, 'source_url', ip);
    // Only checked when the assets/seed/images folder sits next to the file.
    if (f != null && Directory('$dir/images').existsSync() &&
        !File('$dir/images/$f').existsSync()) {
      err('$ip.file', 'image not found at $dir/images/$f');
    }
  });
}

void urlList2(Map m, String k, String p) {
  final v = m[k];
  if (v is! String || !RegExp(r'^https?://\S+$').hasMatch(v)) {
    err('$p.$k', 'must be an http(s) URL, got $v');
  }
}

void screenplay(Map m, String p, String dir) {
  oneOf(m, 'category', p,
      ['element', 'capitalisation', 'transition', 'page', 'fountain']);
  str(m, 'name', p);
  str(m, 'description', p);
  final r = m['rules'];
  if (r != null && r is! Map) err('$p.rules', 'must be an object');
  if (r is Map) {
    r.forEach((k, v) {
      if (v is! String && v is! num && v is! bool) {
        err('$p.rules.$k', 'must be a string, number or boolean');
      }
    });
  }
  strList(m, 'values', p, req: false);
  strList(m, 'examples', p, req: false);
  urlList(m, 'sources', p);
}

void projectType(Map m, String p, String dir) {
  str(m, 'name', p);
  final lo = number(m, 'length_min_seconds', p, min: 1);
  final hi = number(m, 'length_max_seconds', p, req: false, min: 1);
  if (lo != null && hi != null && hi < lo) {
    err('$p.length_max_seconds', 'must be >= length_min_seconds');
  }
  final t = str(m, 'default_template', p);
  if (t != null &&
      !reservedTemplateIds.contains(t) &&
      !t.startsWith('youtube-') &&
      !t.startsWith('shorts-')) {
    err('$p.default_template',
        '"$t" is not a reserved template id (see docs/SEED_SCHEMA.md)');
  }
  final opts = list(m, 'template_options', p, nonEmpty: true);
  if (opts != null) {
    if (opts.length < 2 || opts.length > 4) {
      err('$p.template_options', 'must hold 2–4 template ids, got ${opts.length}');
    }
    for (var i = 0; i < opts.length; i++) {
      slug(opts[i], '$p.template_options[$i]');
    }
    if (opts.isNotEmpty && opts.first != t) {
      err('$p.template_options[0]', 'must equal default_template "$t"');
    }
  }
  oneOf(m, 'writing_section', p, ['screenplay', 'script']);
  slug(m['default_aspect_ratio'], '$p.default_aspect_ratio');
  if (m['has_storyboard'] is! bool) err('$p.has_storyboard', 'must be true or false');
  oneOf(m, 'characters', p, ['yes', 'optional']);
  each(list(m, 'extra_fields', p), '$p.extra_fields', (f, fp) {
    slug(f['id'], '$fp.id');
    str(f, 'name', fp);
    str(f, 'description', fp);
  });
  urlList(m, 'sources', p);
}

void songStructure(Map m, String p, String dir) {
  oneOf(m, 'kind', p, ['section', 'arrangement']);
  str(m, 'name', p);
  str(m, 'description', p);
  if (m['kind'] == 'arrangement') {
    final s = list(m, 'sequence', p, nonEmpty: true);
    for (var i = 0; s != null && i < s.length; i++) {
      slug(s[i], '$p.sequence[$i]');
    }
  }
  urlList(m, 'sources', p, req: false);
}

void relationship(Map m, String p, String dir) {
  str(m, 'name', p);
  oneOf(m, 'group', p,
      ['family', 'social', 'romantic', 'professional', 'conflict', 'debt_obligation']);
  if (m['inverse'] != null) slug(m['inverse'], '$p.inverse');
  if (m['symmetric'] != null && m['symmetric'] is! bool) {
    err('$p.symmetric', 'must be true or false');
  }
}

void aspect(Map m, String p, String dir) {
  str(m, 'name', p);
  final w = number(m, 'width', p, min: 1, integer: true);
  final h = number(m, 'height', p, min: 1, integer: true);
  final r = number(m, 'ratio', p, min: 0.1);
  if (w != null && h != null && r != null && (w / h - r).abs() > 0.01) {
    err('$p.ratio', 'is $r but width/height is ${(w / h).toStringAsFixed(3)}');
  }
  str(m, 'common_uses', p);
}

void unit(Map m, String k, String p) => number(m, k, p, min: 0, max: 1);

void guide(Map m, String p, String dir) {
  str(m, 'name', p);
  str(m, 'description', p);
  oneOf(m, 'kind', p, ['composition', 'safe_area']);
  each(list(m, 'shapes', p, nonEmpty: true), '$p.shapes', (s, sp) {
    switch (oneOf(s, 'type', sp, ['line', 'rect', 'circle', 'polyline'])) {
      case 'line':
        for (final k in ['x1', 'y1', 'x2', 'y2']) {
          unit(s, k, sp);
        }
      case 'rect':
        for (final k in ['x', 'y', 'w', 'h']) {
          unit(s, k, sp);
        }
      case 'circle':
        for (final k in ['cx', 'cy', 'r']) {
          unit(s, k, sp);
        }
      case 'polyline':
        final pts = list(s, 'points', sp, nonEmpty: true);
        for (var i = 0; pts != null && i < pts.length; i++) {
          final pt = pts[i];
          if (pt is! List || pt.length != 2 ||
              pt.any((c) => c is! num || c < 0 || c > 1)) {
            err('$sp.points[$i]', 'must be [x, y] with both in 0..1');
          }
        }
    }
  });
  strList(m, 'tags', p, req: false);
  urlList(m, 'sources', p, req: false);
}

const checks = <String, Check>{
  'templates.json': template,
  'shots_camera.json': shot,
  'shots_look.json': shot,
  'screenplay_format.json': screenplay,
  'project_types.json': projectType,
  'song_structures.json': songStructure,
  'relationship_labels.json': relationship,
  'aspect_ratios.json': aspect,
  'guides.json': guide,
};

void main(List<String> args) => exit(run(args));

int run(List<String> args) {
  if (args.length != 1) {
    stderr.writeln('usage: dart tool/validate_seed.dart <file.json>');
    return 2;
  }
  final file = File(args[0]);
  final name = file.uri.pathSegments.last;
  final check = checks[name];
  if (check == null) {
    stderr.writeln('unknown seed file "$name"; expected one of: ${checks.keys.join(', ')}'
        '${name == 'sample_project.json' ? ' (sample_project.json has its own format, not validated here)' : ''}');
    return 2;
  }
  if (!file.existsSync()) {
    stderr.writeln('file not found: ${args[0]}');
    return 2;
  }
  Object? doc;
  try {
    doc = jsonDecode(file.readAsStringSync());
  } on FormatException catch (e) {
    stderr.writeln('$name: invalid JSON: ${e.message}');
    return 1;
  }
  if (doc is! Map) {
    stderr.writeln('$name: top level must be an object {"version", "items"}');
    return 1;
  }
  number(doc, 'version', r'$', min: 1, integer: true);
  final items = list(doc, 'items', r'$', nonEmpty: true);
  final dir = file.parent.path;
  final seen = <String>{};
  each(items, 'items', (m, p) {
    slug(m['id'], '$p.id');
    if (m['id'] is String && !seen.add(m['id'] as String)) {
      err('$p.id', 'duplicate id "${m['id']}"');
    }
    check(m, p, dir);
  });
  if (name == 'relationship_labels.json') {
    each(items, 'items', (m, p) {
      if (m['inverse'] is String && !seen.contains(m['inverse'])) {
        err('$p.inverse', 'refers to unknown label "${m['inverse']}"');
      }
    });
  }
  if (errors.isEmpty) {
    stdout.writeln('OK $name (${items?.length ?? 0} items)');
    return 0;
  }
  stderr.writeln('INVALID $name: ${errors.length} problem(s)');
  for (final e in errors) {
    stderr.writeln('  $e');
  }
  return 1;
}


