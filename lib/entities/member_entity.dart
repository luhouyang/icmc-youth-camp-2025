class MemberEntity {
  final String id;
  final String name;
  List<dynamic> stations;

  MemberEntity({
    required this.id,
    required this.name,
    required this.stations,
  });

  factory MemberEntity.fromMap(Map<String, dynamic> map) {
    return MemberEntity(
      id: map["id"],
      name: map["name"],
      stations: map["stations"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'stations': stations,
    };
  }
}
