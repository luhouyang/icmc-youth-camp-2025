class GroupEntity {
  final String groupName;
  final List<dynamic> members;
  final int score;
  final int protection;
  final String mentor;

  GroupEntity({
    required this.groupName,
    required this.members,
    required this.score,
    required this.protection,
    required this.mentor,
  });

  factory GroupEntity.fromMap(Map<String, dynamic> map) {
    return GroupEntity(
      groupName: map["groupName"],
      members: map["members"],
      score: map["score"],
      protection: map["protection"],
      mentor: map["mentor"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,
      'members': members,
      'score': score,
      'protection': protection,
      'mentor': mentor,
    };
  }
}
