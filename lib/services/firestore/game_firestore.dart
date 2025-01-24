import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yc_icmc_2025/entities/group_entity.dart';
import 'package:yc_icmc_2025/states/app_state.dart';

class GamesFirestore {
  Future increaseScore(String groupName, int score, AppState appState) async {
    int index = appState.groupList.indexWhere(
      (element) => element.groupName == groupName,
    );
    GroupEntity gameEntity = appState.groupList[index];

    gameEntity.score += score;

    await FirebaseFirestore.instance.collection('groups').doc(gameEntity.id).set(gameEntity.toMap());
  }

  Future decreaseScore(String groupName, int score, AppState appState) async {
    int index = appState.groupList.indexWhere(
      (element) => element.groupName == groupName,
    );
    GroupEntity gameEntity = appState.groupList[index];

    gameEntity.score -= score;

    await FirebaseFirestore.instance.collection('groups').doc(gameEntity.id).set(gameEntity.toMap());
  }

  Future increaseProtect(String groupName, AppState appState) async {
    int index = appState.groupList.indexWhere(
      (element) => element.groupName == groupName,
    );
    GroupEntity gameEntity = appState.groupList[index];

    gameEntity.protection += 1;

    await FirebaseFirestore.instance.collection('groups').doc(gameEntity.id).set(gameEntity.toMap());
  }

  Future decreaseProtect(String groupName, AppState appState) async {
    int index = appState.groupList.indexWhere(
      (element) => element.groupName == groupName,
    );
    GroupEntity gameEntity = appState.groupList[index];

    gameEntity.protection -= 1;

    await FirebaseFirestore.instance.collection('groups').doc(gameEntity.id).set(gameEntity.toMap());
  }

  Future stealScore(String winningGroupName, String losingGroupName, int score, AppState appState) async {
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

    await FirebaseFirestore.instance.collection('groups').doc(losingGameEntity.id).set(losingGameEntity.toMap());
    await FirebaseFirestore.instance.collection('groups').doc(winningGameEntity.id).set(winningGameEntity.toMap());
  }
}
