// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class MarkerModel {
  MarkerModel({
    required this.type,
    required this.name,
    required this.features,
  });

  final String type;
  final String name;
  final List<Feature> features;

  factory MarkerModel.fromRawJson(String str) => MarkerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MarkerModel.fromJson(Map<String, dynamic> json) => MarkerModel(
    type: json["type"],
    name: json["name"],
    features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "name": name,
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
  };
}

class Feature {
  Feature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  final FeatureType type;
  final Properties properties;
  final Geometry geometry;

  factory Feature.fromRawJson(String str) => Feature.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    type: featureTypeValues.map[json["type"]]!,
    properties: Properties.fromJson(json["properties"]),
    geometry: Geometry.fromJson(json["geometry"]),
  );

  Map<String, dynamic> toJson() => {
    "type": featureTypeValues.reverse[type],
    "properties": properties.toJson(),
    "geometry": geometry.toJson(),
  };
}

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  final GeometryType type;
  final List<dynamic> coordinates;

  factory Geometry.fromRawJson(String str) => Geometry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    type: geometryTypeValues.map[json["type"]]!,
    coordinates: List<dynamic>.from(json["coordinates"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": geometryTypeValues.reverse[type],
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

enum GeometryType { lineString, point }

final geometryTypeValues = EnumValues({
  "LineString": GeometryType.lineString,
  "Point": GeometryType.point
});

class Properties {
  Properties({
    required this.name,
    this.line,
    this.description,
    required this.enable,
  });

  final String name;
  final String? line;
  final String? description;
  final bool enable;

  factory Properties.fromRawJson(String str) => Properties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    name: json["Name"],
    line: json["line"],
    description: json["description"],
    enable: json["enable"]
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "line": line,
    "description": description,
    "enable": enable,
  };
}

enum FeatureType { feature }

final featureTypeValues = EnumValues({
  "Feature": FeatureType.feature
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
