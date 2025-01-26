import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yc_icmc_2025/entities/group_entity.dart';
import 'package:yc_icmc_2025/entities/reocrd_entity.dart';
import 'package:yc_icmc_2025/states/app_state.dart';
import 'package:yc_icmc_2025/widgets/cards/group_card.dart';
import 'package:yc_icmc_2025/widgets/cards/record_card.dart';
import 'package:yc_icmc_2025/widgets/loading/loading_widget_large.dart';
import 'package:yc_icmc_2025/widgets/loading/loading_widget_mini.dart';
import 'package:yc_icmc_2025/widgets/texts/h1_text.dart';

class LargeHomePage extends StatefulWidget {
  const LargeHomePage({super.key});

  @override
  State<LargeHomePage> createState() => _LargeHomePageState();
}

class _LargeHomePageState extends State<LargeHomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

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
            double availableScreenWidth = screenWidth - (appState.isNavBarCollapsed ? 75 : 270);
            int crossAxisCount = (availableScreenWidth / 300).floor();
            // double aspectRation = crossAxisCount == 1
            //     ? 1.65
            //     : crossAxisCount == 2
            //         ? availableScreenWidth > 850
            //             ? 1.3
            //             : 0.95
            //         : 0.97;
            double aspectRation = 0.95 + availableScreenWidth / 5000 - crossAxisCount/15;
            double crossAxisSpacing = 8.0;
            double mainAxisSpacing = 8.0;

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/banner.png',
                          height: max(500, screenWidth * 0.35),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: crossAxisSpacing,
                          mainAxisSpacing: mainAxisSpacing,
                          childAspectRatio: aspectRation,
                        ),
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          GroupEntity groupEntity = GroupEntity.fromMap(snapshot.data!.docs[index].data());

                          return GroupCardLarge(groupEntity: groupEntity);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 24,
                    ),
                    const H1Text(text: "RECORD"),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: StreamBuilder(
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
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
