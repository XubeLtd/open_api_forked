import 'package:open_api_forked/src/object.dart';

class APIDiscriminator extends APIObject {
  APIDiscriminator({this.propertyName, Map<String, String>? mapping}) {
    if (mapping != null) {
      this.mapping = Map.of(mapping);
    }
  }

  String? propertyName;

  Map<String, String> mapping = {};

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    propertyName = object.decode("propertyName");
    final rawMapping = object.decode("mapping");
    if (rawMapping is Map) {
      mapping = rawMapping.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
  }

  @override
  void encode(KeyedArchive object) {
    super.encode(object);
    object.encode("propertyName", propertyName);
    if (mapping.isNotEmpty) {
      object.encode("mapping", mapping);
    }
  }

  String? resolve(String? value) {
    if (value == null) return null;
    return mapping[value];
  }
}
