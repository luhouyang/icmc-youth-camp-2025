import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yc_icmc_2025/entities/group_entity.dart';
import 'package:yc_icmc_2025/entities/member_entity.dart';
// import 'package:yc_icmc_2025/entities/member_entity.dart';
import 'package:yc_icmc_2025/entities/reocrd_entity.dart';
import 'package:yc_icmc_2025/enums/record_enum.dart';
import 'package:yc_icmc_2025/states/app_state.dart';

class GamesFirestore {
  Future increaseScore(String groupName, int score, AppState appState) async {
    // init batch
    FirebaseFirestore db = FirebaseFirestore.instance;
    final batch = db.batch();

    // score update
    int index = appState.groupList.indexWhere(
      (element) => element.groupName == groupName,
    );
    GroupEntity gameEntity = appState.groupList[index];

    gameEntity.score += score;

    batch.set(db.collection('groups').doc(gameEntity.id), gameEntity.toMap());

    // add record
    DocumentReference recRef = db.collection('records').doc();
    RecordEntity recordEntity = RecordEntity(
      id: recRef.id,
      winner: gameEntity.id,
      recordType: RecordEnum.increase.value,
      createdAt: Timestamp.now(),
      score: score,
    );

    batch.set(recRef, recordEntity.toMap());

    await batch.commit();
  }

  Future decreaseScore(String groupName, int score, AppState appState) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final batch = db.batch();

    // score update
    int index = appState.groupList.indexWhere(
      (element) => element.groupName == groupName,
    );
    GroupEntity gameEntity = appState.groupList[index];

    gameEntity.score -= score;

    batch.set(db.collection('groups').doc(gameEntity.id), gameEntity.toMap());

    // add record
    DocumentReference recRef = db.collection('records').doc();
    RecordEntity recordEntity = RecordEntity(
      id: recRef.id,
      winner: gameEntity.id,
      recordType: RecordEnum.decrease.value,
      createdAt: Timestamp.now(),
      score: score,
    );

    batch.set(recRef, recordEntity.toMap());

    await batch.commit();
  }

  Future increaseProtect(String groupName, AppState appState) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final batch = db.batch();

    // increase protect
    int index = appState.groupList.indexWhere(
      (element) => element.groupName == groupName,
    );
    GroupEntity gameEntity = appState.groupList[index];

    gameEntity.protection += 1;

    batch.set(db.collection('groups').doc(gameEntity.id), gameEntity.toMap());

    // add record
    // DocumentReference recRef = db.collection('records').doc();
    // RecordEntity recordEntity = RecordEntity(
    //   id: recRef.id,
    //   winner: gameEntity.id,
    //   recordType: RecordEnum.protect.value,
    //   createdAt: Timestamp.now(),
    // );

    // batch.set(recRef, recordEntity.toMap());

    // await batch.commit();
  }

  Future decreaseProtect(String groupName, AppState appState) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final batch = db.batch();

    // decrease protect
    int index = appState.groupList.indexWhere(
      (element) => element.groupName == groupName,
    );
    GroupEntity gameEntity = appState.groupList[index];

    gameEntity.protection -= 1;

    batch.set(db.collection('groups').doc(gameEntity.id), gameEntity.toMap());

    // add record
    // DocumentReference recRef = db.collection('records').doc();
    // RecordEntity recordEntity = RecordEntity(
    //   id: recRef.id,
    //   winner: gameEntity.id,
    //   recordType: RecordEnum.shield.value,
    //   createdAt: Timestamp.now(),
    // );

    // batch.set(recRef, recordEntity.toMap());

    // batch.commit();
  }

  Future stealScore(String winningGroupName, String losingGroupName, int score, AppState appState) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final batch = db.batch();

    // steal score
    int winningIndex = appState.groupList.indexWhere(
      (element) => element.groupName == winningGroupName,
    );
    GroupEntity winningGameEntity = appState.groupList[winningIndex];

    int losingIndex = appState.groupList.indexWhere(
      (element) => element.groupName == losingGroupName,
    );
    GroupEntity losingGameEntity = appState.groupList[losingIndex];

    losingGameEntity.score -= score;
    winningGameEntity.score += score;

    batch.set(db.collection('groups').doc(losingGameEntity.id), losingGameEntity.toMap());
    batch.set(db.collection('groups').doc(winningGameEntity.id), winningGameEntity.toMap());

    // add record
    DocumentReference recRef = db.collection('records').doc();
    RecordEntity recordEntity = RecordEntity(
      id: recRef.id,
      winner: winningGameEntity.id,
      loser: losingGameEntity.id,
      recordType: RecordEnum.steal.value,
      createdAt: Timestamp.now(),
      score: score,
    );

    batch.set(recRef, recordEntity.toMap());

    await batch.commit();
  }

  Future deleteRecord(RecordEntity recordEntity, AppState appState) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final batch = db.batch();

    int winningIndex = appState.groupList.indexWhere(
      (element) => element.id == recordEntity.winner,
    );
    GroupEntity winningGroupEntity = appState.groupList[winningIndex];

    if (recordEntity.recordType == RecordEnum.increase.value) {
      winningGroupEntity.score -= recordEntity.score!;
    } else if (recordEntity.recordType == RecordEnum.decrease.value) {
      winningGroupEntity.score += recordEntity.score!;
    } 
    // else if (recordEntity.recordType == RecordEnum.protect.value) {
    //   winningGroupEntity.protection -= 1;
    // } 
    // else if (recordEntity.recordType == RecordEnum.shield.value) {
    //   winningGroupEntity.protection += 1;
    // } 
    else if (recordEntity.recordType == RecordEnum.steal.value) {
      int lossingIndex = appState.groupList.indexWhere(
        (element) => element.id == recordEntity.loser,
      );
      GroupEntity lossingGroupEntity = appState.groupList[lossingIndex];

      winningGroupEntity.score -= recordEntity.score!;
      lossingGroupEntity.score += recordEntity.score!;

      batch.set(db.collection('groups').doc(lossingGroupEntity.id), lossingGroupEntity.toMap());
    }

    batch.set(db.collection('groups').doc(winningGroupEntity.id), winningGroupEntity.toMap());
    batch.delete(db.collection('records').doc(recordEntity.id));

    await batch.commit();
  }

  // Future addMember(GroupEntity groupEntity) async {
  //   List<Timestamp> stationList = List.generate(
  //     20,
  //     (index) => Timestamp.now(),
  //   );

  //   List<dynamic> memberList = List.generate(
  //     10,
  //     (index) {
  //       DocumentReference recRef = FirebaseFirestore.instance.collection('groups').doc();
  //       return MemberEntity(id: recRef.id, name: "PERSON $index", stations: stationList).toMap();
  //     },
  //   );

  //   groupEntity.members = memberList;

  //   await FirebaseFirestore.instance.collection('groups').doc(groupEntity.id).set(groupEntity.toMap());
  // }

  Future confirmMember(String groupName, String playerId, int station, AppState appState) async {
    int index = appState.groupList.indexWhere(
      (element) => element.groupName == groupName,
    );
    GroupEntity gameEntity = appState.groupList[index];

    List<MemberEntity> memberEntityList = gameEntity.members
        .map(
          (e) => MemberEntity.fromMap(e as Map<String, dynamic>),
        )
        .toList();

    int playerIdx = memberEntityList.indexWhere(
      (element) => element.id == playerId,
    );

    MemberEntity player = memberEntityList[playerIdx];

    List<Timestamp> stations = player.stations
        .map(
          (e) => e as Timestamp,
        )
        .toList();

    stations[station] = Timestamp.now();

    player.stations = stations;
    memberEntityList[playerIdx] = player;
    gameEntity.members = memberEntityList.map((e) => e.toMap(),).toList();

    await FirebaseFirestore.instance.collection('groups').doc(gameEntity.id).set(gameEntity.toMap());
  }
}
