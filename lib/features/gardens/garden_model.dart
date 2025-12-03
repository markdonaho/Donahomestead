import 'package:cloud_firestore/cloud_firestore.dart';

class GardenZone {
  final String type; // 'row', 'walkway', 'bed'
  final String? content; // e.g., 'Potatoes'
  final String? status; // e.g., 'planted', 'sprouting'
  final String? width; // e.g., '2ft'

  GardenZone({
    required this.type,
    this.content,
    this.status,
    this.width,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'content': content,
      'status': status,
      'width': width,
    };
  }

  factory GardenZone.fromMap(Map<String, dynamic> map) {
    return GardenZone(
      type: map['type'] ?? 'row',
      content: map['content'],
      status: map['status'],
      width: map['width'],
    );
  }

  GardenZone copyWith({
    String? type,
    String? content,
    String? status,
    String? width,
  }) {
    return GardenZone(
      type: type ?? this.type,
      content: content ?? this.content,
      status: status ?? this.status,
      width: width ?? this.width,
    );
  }
}

class Garden {
  final String id;
  final String name;
  final List<GardenZone> zones;

  Garden({
    required this.id,
    required this.name,
    required this.zones,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'zones': zones.map((z) => z.toMap()).toList(),
    };
  }

  factory Garden.fromMap(Map<String, dynamic> map, String id) {
    return Garden(
      id: id,
      name: map['name'] ?? '',
      zones: (map['zones'] as List<dynamic>?)
              ?.map((z) => GardenZone.fromMap(z as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Garden copyWith({
    String? id,
    String? name,
    List<GardenZone>? zones,
  }) {
    return Garden(
      id: id ?? this.id,
      name: name ?? this.name,
      zones: zones ?? this.zones,
    );
  }
}
