import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yc_icmc_2025/entities/reocrd_entity.dart';
import 'package:yc_icmc_2025/enums/record_enum.dart';
import 'package:yc_icmc_2025/services/firestore/game_firestore.dart';
import 'package:yc_icmc_2025/states/app_state.dart';
import 'package:yc_icmc_2025/widgets/loading/loading_widget.dart';
import 'package:yc_icmc_2025/widgets/texts/snack_bar_text.dart';
import 'package:yc_icmc_2025/widgets/ui_color.dart';

class RecordCard extends StatefulWidget {
  final RecordEntity recordEntity;
  final AppState appState;

  const RecordCard({super.key, required this.recordEntity, required this.appState});

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  @override
  Widget build(BuildContext context) {
    int winnerIndex = widget.appState.groupList.indexWhere(
      (element) => element.id == widget.recordEntity.winner,
    );

    int loserIndex = widget.recordEntity.loser == null
        ? -1
        : widget.appState.groupList.indexWhere(
            (element) => element.id == widget.recordEntity.loser,
          );

    Widget getRow() {
      if (widget.recordEntity.recordType == RecordEnum.increase.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.appState.groupList[winnerIndex].groupName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 16,
            ),
            Icon(
              Icons.add,
              color: UIColor().brightBlue,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              widget.recordEntity.score.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else if (widget.recordEntity.recordType == RecordEnum.decrease.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.appState.groupList[winnerIndex].groupName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 16,
            ),
            Icon(
              Icons.cancel_outlined,
              color: UIColor().primaryRed,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              widget.recordEntity.score.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else if (widget.recordEntity.recordType == RecordEnum.protect.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.appState.groupList[winnerIndex].groupName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 16,
            ),
            Icon(
              Icons.shield,
              color: UIColor().brightBlue,
            ),
            const SizedBox(
              width: 16,
            ),
            const Text(
              "1",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else if (widget.recordEntity.recordType == RecordEnum.shield.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.appState.groupList[winnerIndex].groupName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 16,
            ),
            Icon(
              Icons.shield,
              color: UIColor().primaryRed,
            ),
            const SizedBox(
              width: 16,
            ),
            const Text(
              "1",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else if (widget.recordEntity.recordType == RecordEnum.steal.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.appState.groupList[winnerIndex].groupName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 16,
            ),
            Icon(
              Icons.monetization_on_outlined,
              color: UIColor().brightBlue,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              widget.recordEntity.score.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              widget.appState.groupList[loserIndex].groupName,
              style: TextStyle(fontWeight: FontWeight.bold, color: UIColor().primaryRed),
            ),
          ],
        );
      }
      return const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("ERROR"),
        ],
      );
    }

    return Container(
        margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
        height: 48,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: getRow(),
            ),
            const Expanded(child: SizedBox()),
            if (FirebaseAuth.instance.currentUser != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                ),
                onPressed: () async {
                  SnackBarText().showBanner(msg: "Deleting record", context: context);

                  await GamesFirestore().deleteRecord(widget.recordEntity, widget.appState);
                },
                child: Text(
                  "DELETE",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
          ],
        ));
  }
}
