class GroupEntity {
  final String id;
  final String groupName;
  final List<dynamic> members;
  int score;
  int protection;
  final String mentor;

  GroupEntity({
    required this.id,
    required this.groupName,
    required this.members,
    required this.score,
    required this.protection,
    required this.mentor,
  });

  factory GroupEntity.fromMap(Map<String, dynamic> map) {
    return GroupEntity(
      id: map["id"],
      groupName: map["groupName"],
      members: map["members"],
      score: map["score"],
      protection: map["protection"],
      mentor: map["mentor"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupName': groupName,
      'members': members,
      'score': score,
      'protection': protection,
      'mentor': mentor,
    };
  }
}
