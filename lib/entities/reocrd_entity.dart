import 'package:cloud_firestore/cloud_firestore.dart';

class RecordEntity {
  final String id;
  final String winner;
  final String? loser;
  final String recordType;
  final int? score;
  final Timestamp createdAt;

  RecordEntity({
    required this.id,
    required this.winner,
    this.loser,
    required this.recordType,
    this.score,
    required this.createdAt,
  });

  factory RecordEntity.fromMap(Map<String, dynamic> map) {
    return RecordEntity(
      id: map["id"],
      winner: map["winner"],
      loser: map["loser"] ?? "NONE",
      recordType: map["recordType"],
      score: map["score"] ?? 0,
      createdAt: map["createdAt"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'winner': winner,
      'loser': loser,
      'recordType': recordType,
      'score': score,
      'createdAt': createdAt,
    };
  }
}
