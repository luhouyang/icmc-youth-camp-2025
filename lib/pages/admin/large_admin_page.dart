import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yc_icmc_2025/entities/group_entity.dart';
import 'package:yc_icmc_2025/entities/reocrd_entity.dart';
import 'package:yc_icmc_2025/pages/admin/large_game_page.dart';
// import 'package:yc_icmc_2025/services/firestore/game_firestore.dart';
import 'package:yc_icmc_2025/states/app_state.dart';
import 'package:yc_icmc_2025/widgets/cards/record_card.dart';
import 'package:yc_icmc_2025/widgets/loading/loading_widget_large.dart';
import 'package:yc_icmc_2025/widgets/loading/loading_widget_mini.dart';
import 'package:yc_icmc_2025/widgets/texts/h1_text.dart';

class LargeAdminPage extends StatefulWidget {
  const LargeAdminPage({super.key});

  @override
  State<LargeAdminPage> createState() => _LargeAdminPageState();
}

class _LargeAdminPageState extends State<LargeAdminPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingWidgetLarge();
          }

          List<GroupEntity> gplst = snapshot.data!.docs
              .map(
                (e) => GroupEntity.fromMap(e.data()),
              )
              .toList();

          AppState untrackedAppState = Provider.of<AppState>(context, listen: false);
          untrackedAppState.setGroupList(gplst);

          return Consumer<AppState>(
            builder: (context, appState, child) {
              return Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisSize: MainAxisSize.max,
                            //   children: [
                            //     Expanded(
                            //       child: ElevatedButton(
                            //         style: ElevatedButton.styleFrom(
                            //           padding: const EdgeInsets.all(14),
                            //         ),
                            //         onPressed: () async {
                            //           for (GroupEntity element in appState.groupList) {
                            //             GamesFirestore().addMember(element);
                            //           }
                            //         },
                            //         child: Text(
                            //           "ADD DETAILS",
                            //           style: Theme.of(context).textTheme.headlineMedium,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const LargeGamePage(),
                            const SizedBox(
                              height: 36,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 24,
                            ),
                            const H1Text(text: "RECORD"),
                            const SizedBox(
                              height: 8,
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('records').orderBy('createdAt', descending: true).snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const LoadingWidgetMini(height: 48);
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.size,
                                  itemBuilder: (context, index) {
                                    RecordEntity recordEntity = RecordEntity.fromMap(snapshot.data!.docs[index].data());

                                    return RecordCard(
                                      recordEntity: recordEntity,
                                      appState: appState,
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        )),
                  ),
                ),
              );
            },
          );
        });
  }
}
