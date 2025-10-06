import 'package:open_api_forked/src/object.dart';

/// Represents an OpenAPI 3.0 discriminator object.
///
/// The discriminator is a specific object in an OpenAPI schema which is used to aid in
/// serialization, deserialization, and validation when request bodies or response payloads
/// may be one of a number of different object types (a polymorphic schema using oneOf/anyOf/allOf).
///
/// See: https://spec.openapis.org/oas/latest.html#discriminator-object
class APIDiscriminator extends APIObject {
  APIDiscriminator({this.propertyName, Map<String, String>? mapping}) {
    if (mapping != null) {
      this.mapping = Map.of(mapping);
    }
  }

  /// The name of the property in the payload that will hold the discriminator value.
  String? propertyName;

  /// An optional mapping of discriminator value -> schema reference ($ref path or model key).
  ///
  /// Keys are the values that may appear in the instance. Values are the original schema
  /// references (often a `#/components/schemas/ModelName`).
  Map<String, String> mapping = {};

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    propertyName = object.decode("propertyName");
    final rawMapping = object.decode("mapping");
    if (rawMapping is Map) {
      // Force cast to Map<String, String>
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

  /// Resolve a schema reference for a given discriminator value.
  ///
  /// If no explicit mapping is provided for [value], returns `null` allowing callers to
  /// fallback to implicit resolution (commonly by appending the value to a known namespace
  /// or using the schema name directly).
  String? resolve(String? value) {
    if (value == null) return null;
    return mapping[value];
  }
}
