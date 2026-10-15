import 'dart:convert';

import 'package:drift/drift.dart';

/// JSON array of strings (tags, ids). Shapes: docs/DATA_MODEL.md.
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();
  @override
  List<String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List).cast<String>();
  @override
  String toSql(List<String> value) => jsonEncode(value);
}

/// JSON object (type_fields, ai_permissions, viewport, snapshot data...).
class JsonMapConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonMapConverter();
  @override
  Map<String, dynamic> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as Map).cast<String, dynamic>();
  @override
  String toSql(Map<String, dynamic> value) => jsonEncode(value);
}

/// JSON array of objects (spans, blocks, nodes, change-ops...).
class JsonListConverter extends TypeConverter<List<dynamic>, String> {
  const JsonListConverter();
  @override
  List<dynamic> fromSql(String fromDb) => jsonDecode(fromDb) as List;
  @override
  String toSql(List<dynamic> value) => jsonEncode(value);
}

/// Enum <-> snake_case TEXT. Unknown values throw (DATA_MODEL section 0).
class EnumConverter<E extends Enum> extends TypeConverter<E, String> {
  const EnumConverter(this.values);
  final List<E> values;

  static String _snake(String s) =>
      s.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

  @override
  E fromSql(String fromDb) => values.firstWhere(
        (e) => _snake(e.name) == fromDb,
        orElse: () => throw ArgumentError('Unknown $E value: $fromDb'),
      );
  @override
  String toSql(E value) => _snake(value.name);
}

// Public: generated code references these by name.
const strListJson = StringListConverter();
const mapJson = JsonMapConverter();
const listJson = JsonListConverter();
