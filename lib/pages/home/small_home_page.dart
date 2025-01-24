import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yc_icmc_2025/entities/group_entity.dart';
import 'package:yc_icmc_2025/states/app_state.dart';
import 'package:yc_icmc_2025/states/constants.dart';
import 'package:yc_icmc_2025/widgets/cards/group_card_small.dart';
import 'package:yc_icmc_2025/widgets/loading/loading_widget_large.dart';

class SmallHomePage extends StatefulWidget {
  const SmallHomePage({super.key});

  @override
  State<SmallHomePage> createState() => _SmallHomePageState();
}

class _SmallHomePageState extends State<SmallHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
              int crossAxisCount = 2;
              double aspectRation = max(screenWidth / 2, 150) / min(screenWidth / 2, 150) * 0.75;
              double crossAxisSpacing = 4.0;
              double mainAxisSpacing = 4.0;

              return Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(Constants().smallScreenPadding),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              'assets/banner.png',
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
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

                              return GroupCardSmall(groupEntity: groupEntity);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
