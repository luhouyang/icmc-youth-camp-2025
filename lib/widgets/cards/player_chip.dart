import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yc_icmc_2025/entities/member_entity.dart';
import 'package:yc_icmc_2025/services/firestore/game_firestore.dart';
import 'package:yc_icmc_2025/states/app_state.dart';
import 'package:yc_icmc_2025/states/constants.dart';
import 'package:yc_icmc_2025/widgets/loading/loading_widget.dart';
import 'package:yc_icmc_2025/widgets/texts/snack_bar_text.dart';
import 'package:yc_icmc_2025/widgets/ui_color.dart';

class PlayerChip extends StatefulWidget {
  final int station;
  // final AppState appState;

  const PlayerChip({super.key, required this.station});

  @override
  State<PlayerChip> createState() => _PlayerChipState();
}

class _PlayerChipState extends State<PlayerChip> {
  String selectedGroup = "";
  String selectedMember = "";

  UniqueKey memberKey = UniqueKey();

  final _playerForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    double fieldScale = screenWidth > Constants().largeScreenWidth ? 0.15 : 0.45;

    AppState appState = Provider.of<AppState>(context, listen: false);

    bool checkStatus() {
      List<dynamic> mml = appState.groupList
          .where(
            (element) => element.groupName == selectedGroup,
          )
          .first
          .members;

      List<MemberEntity> members = List.generate(
        mml.length,
        (index) {
          return MemberEntity.fromMap(mml[index] as Map<String, dynamic>);
        },
      );

      List<Timestamp> stationList = members
          .where(
            (element) => element.id == selectedMember,
          )
          .first
          .stations
          .map(
            (e) => e as Timestamp,
          )
          .toList();

      DateTime timenow = DateTime.now();

      Duration diff = timenow.difference(stationList[widget.station - 1].toDate());

      int lim = 15 * 60;

      if (diff.inSeconds > lim) {
        return true;
      } else {
        return false;
      }
    }

    return Padding(
      padding: EdgeInsets.all(screenWidth > Constants().largeScreenWidth ? 8.0 : 0.0),
      child: Form(
        key: _playerForm,
        child: screenWidth > Constants().largeScreenWidth
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * fieldScale,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      hint: Text(
                        "group",
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      items: appState.groupList.map(
                        (e) {
                          return DropdownMenuItem<String>(value: e.groupName, child: Text(e.groupName));
                        },
                      ).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Select a group';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          selectedMember = "";
                          memberKey = UniqueKey();
                          selectedGroup = value.toString();
                        });
                      },
                      onSaved: (value) {},
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Theme.of(context).inputDecorationTheme.fillColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  if (selectedGroup != "" && selectedGroup.isNotEmpty)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * fieldScale,
                      child: DropdownButtonFormField2<String>(
                        key: memberKey,
                        isExpanded: true,
                        hint: Text(
                          "member",
                          style: Theme.of(context).inputDecorationTheme.hintStyle,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        items: appState.groupList
                            .where(
                              (element) => element.groupName == selectedGroup,
                            )
                            .first
                            .members
                            .map(
                          (e) {
                            MemberEntity memberEntity = MemberEntity.fromMap(e as Map<String, dynamic>);
                            return DropdownMenuItem<String>(
                              value: memberEntity.id,
                              child: Text(memberEntity.name),
                            );
                          },
                        ).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Select a member';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedMember = value.toString();
                          });
                        },
                        onSaved: (value) {},
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 24,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            color: Theme.of(context).inputDecorationTheme.fillColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 16,
                  ),
                  if (selectedGroup != "" && selectedGroup.isNotEmpty && selectedMember != "" && selectedMember.isNotEmpty)
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: checkStatus() ? UIColor().primaryGreen : UIColor().primaryRed,
                      ),
                    ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  if (selectedGroup != "" && selectedGroup.isNotEmpty && selectedMember != "" && selectedMember.isNotEmpty && checkStatus())
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () async {
                        if (_playerForm.currentState!.validate()) {
                          SnackBarText().showBanner(msg: "Updating record", context: context);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return LoadingWidget().circularLoadingWidget(context);
                            },
                          );

                          // debugPrint("$selectedGroup $selectedMember ${widget.station}");

                          await GamesFirestore().confirmMember(selectedGroup, selectedMember, widget.station - 1, appState);

                          if (context.mounted) {
                            Navigator.of(context).pop();
                            setState(() {});
                          }
                        }
                      },
                      child: Text(
                        "CONFIRM PLAYER",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * fieldScale,
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          hint: Text(
                            "group",
                            style: Theme.of(context).inputDecorationTheme.hintStyle,
                          ),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          items: appState.groupList.map(
                            (e) {
                              return DropdownMenuItem<String>(value: e.groupName, child: Text(e.groupName));
                            },
                          ).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Select a group';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              selectedMember = "";
                              memberKey = UniqueKey();
                              selectedGroup = value.toString();
                            });
                          },
                          onSaved: (value) {},
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              color: Theme.of(context).inputDecorationTheme.fillColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      if (selectedGroup != "" && selectedGroup.isNotEmpty)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * fieldScale,
                          child: DropdownButtonFormField2<String>(
                            key: memberKey,
                            isExpanded: true,
                            hint: Text(
                              "member",
                              style: Theme.of(context).inputDecorationTheme.hintStyle,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            items: appState.groupList
                                .where(
                                  (element) => element.groupName == selectedGroup,
                                )
                                .first
                                .members
                                .map(
                              (e) {
                                MemberEntity memberEntity = MemberEntity.fromMap(e as Map<String, dynamic>);
                                return DropdownMenuItem<String>(
                                  value: memberEntity.id,
                                  child: Text(memberEntity.name),
                                );
                              },
                            ).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Select a member';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                selectedMember = value.toString();
                              });
                            },
                            onSaved: (value) {},
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.only(right: 8),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 24,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                color: Theme.of(context).inputDecorationTheme.fillColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      if (selectedGroup != "" && selectedGroup.isNotEmpty && selectedMember != "" && selectedMember.isNotEmpty)
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: checkStatus() ? UIColor().primaryGreen : UIColor().primaryRed,
                          ),
                        ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      if (selectedGroup != "" && selectedGroup.isNotEmpty && selectedMember != "" && selectedMember.isNotEmpty && checkStatus())
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(8),
                          ),
                          onPressed: () async {
                            if (_playerForm.currentState!.validate()) {
                              SnackBarText().showBanner(msg: "Updating record", context: context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return LoadingWidget().circularLoadingWidget(context);
                                },
                              );

                              // debugPrint("$selectedGroup $selectedMember ${widget.station}");

                              await GamesFirestore().confirmMember(selectedGroup, selectedMember, widget.station - 1, appState);

                              if (context.mounted) {
                                Navigator.of(context).pop();
                                setState(() {});
                              }
                            }
                          },
                          child: Text(
                            "CONFIRM PLAYER",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
      ),
    );

    // return Consumer<AppState>(builder: (context, appState, child) {

    // });
  }
}
