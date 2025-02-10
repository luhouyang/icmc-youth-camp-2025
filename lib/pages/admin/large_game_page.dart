import 'dart:async';
import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:provider/provider.dart';
import 'package:yc_icmc_2025/entities/group_entity.dart';
import 'package:yc_icmc_2025/entities/member_entity.dart';
import 'package:yc_icmc_2025/enums/record_enum.dart';
import 'package:yc_icmc_2025/services/firestore/game_firestore.dart';
import 'package:yc_icmc_2025/states/app_state.dart';
import 'package:yc_icmc_2025/widgets/cards/player_chip.dart';
import 'package:yc_icmc_2025/widgets/fields/text_input.dart';
import 'package:yc_icmc_2025/widgets/loading/loading_widget.dart';
import 'package:yc_icmc_2025/widgets/texts/h1_text.dart';
import 'package:yc_icmc_2025/widgets/texts/snack_bar_text.dart';
import 'package:yc_icmc_2025/widgets/ui_color.dart';

class LargeGamePage extends StatefulWidget {
  const LargeGamePage({super.key});

  @override
  State<LargeGamePage> createState() => _LargeGamePageState();
}

class _LargeGamePageState extends State<LargeGamePage> {
  final _playerForm = GlobalKey<FormState>();

  String _recordType = RecordEnum.increase.value;
  int _numPlayers = 0;
  int _stationNum = 0;

  final _increaseFormKey = GlobalKey<FormState>();
  final TextEditingController _increaseTextController = TextEditingController();

  final _decreaseFormKey = GlobalKey<FormState>();
  final TextEditingController _decreaseTextController = TextEditingController();

  final _protectFormKey = GlobalKey<FormState>();

  final _stealFormKey = GlobalKey<FormState>();
  final TextEditingController _stealTextController = TextEditingController();

  String winningGroupName = "";
  String losingGroupName = "";

  StreamController<int> selected = StreamController<int>();

  bool playersValid = false;

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    final numPlayersList = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    final stationNumberList = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

    final items = <String>[
      'Increase',
      'Decrease',
      'Protect',
      'Steal',
    ];

    bool hasProtectPoint(String groupName, AppState appState) {
      int index = appState.groupList.indexWhere(
        (element) => element.groupName == groupName,
      );
      GroupEntity gameEntity = appState.groupList[index];

      if (gameEntity.protection > 0) {
        return true;
      } else {
        return false;
      }
    }

    Widget increaseWidget(AppState appState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1Text(text: "ADD INCREASE RECORD"),
          const SizedBox(
            height: 16,
          ),
          Form(
            key: _increaseFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("WINNER: "),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
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
                            winningGroupName = value.toString();
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
                  width: 16,
                ),
                TextInputs().inputTextWidget(
                  hint: "amount",
                  validator: TextInputs().intNumberVerify,
                  controller: _increaseTextController,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                        ),
                        onPressed: () async {
                          if (_increaseFormKey.currentState!.validate()) {
                            SnackBarText().showBanner(
                                msg: "Increasing score of $winningGroupName by ${int.parse(_increaseTextController.text)}", context: context);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return LoadingWidget().circularLoadingWidget(context);
                              },
                            );
                            await GamesFirestore().increaseScore(
                              winningGroupName,
                              int.parse(_increaseTextController.text),
                              appState,
                            );

                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: Text(
                          "SUBMIT",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget decreaseWidget(AppState appState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1Text(text: "ADD DECREASE RECORD"),
          const SizedBox(
            height: 16,
          ),
          Form(
            key: _decreaseFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("WINNER: "),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
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
                            winningGroupName = value.toString();
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
                  width: 16,
                ),
                TextInputs().inputTextWidget(
                  hint: "amount",
                  validator: TextInputs().intNumberVerify,
                  controller: _decreaseTextController,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                        ),
                        onPressed: () async {
                          if (_decreaseFormKey.currentState!.validate()) {
                            if (hasProtectPoint(winningGroupName, appState)) {
                              SnackBarText().showBanner(msg: "Decreasing protect point of $winningGroupName by 1", context: context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return LoadingWidget().circularLoadingWidget(context);
                                },
                              );

                              await GamesFirestore().decreaseProtect(winningGroupName, appState);

                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            } else {
                              SnackBarText().showBanner(
                                  msg: "Decreasing score of $winningGroupName by ${int.parse(_decreaseTextController.text)}", context: context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return LoadingWidget().circularLoadingWidget(context);
                                },
                              );

                              await GamesFirestore().decreaseScore(
                                winningGroupName,
                                int.parse(_decreaseTextController.text),
                                appState,
                              );

                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          }
                        },
                        child: Text(
                          "SUBMIT",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget protectWidget(AppState appState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1Text(text: "ADD PROTECT RECORD"),
          const SizedBox(
            height: 16,
          ),
          Form(
            key: _protectFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("WINNER: "),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
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
                            winningGroupName = value.toString();
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
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                        ),
                        onPressed: () async {
                          if (_protectFormKey.currentState!.validate()) {
                            SnackBarText().showBanner(msg: "Increasing score of $winningGroupName by 1", context: context);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return LoadingWidget().circularLoadingWidget(context);
                              },
                            );

                            await GamesFirestore().increaseProtect(
                              winningGroupName,
                              appState,
                            );

                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: Text(
                          "SUBMIT",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget stealWidget(AppState appState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1Text(text: "ADD STEAL RECORD"),
          const SizedBox(
            height: 16,
          ),
          Form(
            key: _stealFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("WINNER: "),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
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
                            winningGroupName = value.toString();
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
                TextInputs().inputTextWidget(
                  hint: "amount",
                  validator: TextInputs().intNumberVerify,
                  controller: _stealTextController,
                ),
                Row(
                  children: [
                    const Text("STEAL: "),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
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
                            losingGroupName = value.toString();
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
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                        ),
                        onPressed: () async {
                          if (_stealFormKey.currentState!.validate()) {
                            if (hasProtectPoint(losingGroupName, appState)) {
                              SnackBarText().showBanner(msg: "Decreasing protect point of $losingGroupName by 1", context: context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return LoadingWidget().circularLoadingWidget(context);
                                },
                              );

                              await GamesFirestore().decreaseProtect(losingGroupName, appState);

                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            } else {
                              SnackBarText().showBanner(
                                  msg: "Adding score of $losingGroupName to $winningGroupName by ${int.parse(_stealTextController.text)}",
                                  context: context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return LoadingWidget().circularLoadingWidget(context);
                                },
                              );

                              await GamesFirestore().stealScore(
                                winningGroupName,
                                losingGroupName,
                                int.parse(_stealTextController.text),
                                appState,
                              );

                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          }
                        },
                        child: Text(
                          "SUBMIT",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget getForm(AppState appState) {
      if (_recordType == RecordEnum.increase.value) {
        return increaseWidget(appState);
      } else if (_recordType == RecordEnum.decrease.value) {
        return decreaseWidget(appState);
      } else if (_recordType == RecordEnum.protect.value) {
        return protectWidget(appState);
      } else if (_recordType == RecordEnum.steal.value) {
        return stealWidget(appState);
      }
      return increaseWidget(appState);
    }

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return SizedBox(
          width: double.infinity,
          child: playersValid
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(14),
                          ),
                          onPressed: () {
                            setState(() {
                              playersValid = false;
                              selected.close();
                            });
                          },
                          child: Text(
                            "CHECK PLAYER",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      height: min(screenWidth * 0.5, 600),
                      child: Column(
                        children: [
                          Expanded(
                            child: FortuneWheel(
                              animateFirst: false,
                              selected: selected.stream,
                              indicators: <FortuneIndicator>[
                                FortuneIndicator(
                                  alignment: Alignment.topCenter, // <-- changing the position of the indicator
                                  child: TriangleIndicator(
                                    color: appState.isDarkMode
                                        ? UIColor().transparentSecondaryOrange
                                        : UIColor().transparentSecondaryBlue, // <-- changing the color of the indicator
                                    width: 50.0, // <-- changing the width of the indicator
                                    height: 50.0, // <-- changing the height of the indicator
                                    elevation: 5, // <-- changing the elevation of the indicator
                                  ),
                                ),
                              ],
                              items: [
                                for (var it in items.asMap().entries)
                                  FortuneItem(
                                    style: FortuneItemStyle(
                                      color: it.key % 2 == 0 ? Theme.of(context).primaryColor : Theme.of(context).highlightColor,
                                    ),
                                    child: Text(
                                      it.value,
                                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                            color: it.key % 2 == 0 ? Theme.of(context).highlightColor : Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        setState(() {
                          selected.add(Fortune.randomInt(0, items.length));
                        });
                      },
                      child: Text(
                        "ROLL",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        const Text("RECORD: "),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: DropdownButtonFormField2<String>(
                            isExpanded: true,
                            hint: Text(
                              "type",
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
                            items: RecordEnum.values.map(
                              (e) {
                                if (e.value != RecordEnum.shield.value) {
                                  return DropdownMenuItem<String>(value: e.value, child: Text(e.value));
                                } else {
                                  return const DropdownMenuItem<String>(value: "", child: Text(""));
                                }
                              },
                            ).toList(),
                            validator: (value) {
                              if (value == null || value == "") {
                                return 'Select a record type';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _recordType = value.toString();
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
                      height: 36,
                    ),
                    getForm(appState),
                  ],
                )
              : Form(
                  key: _playerForm,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(14),
                            ),
                            onPressed: () {
                              setState(() {
                                playersValid = true;
                                selected = StreamController<int>();
                              });
                            },
                            child: Text(
                              "MODIFY POINTS",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          const Text("NUMBER OF PLAYERS: "),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: DropdownButtonFormField2<String>(
                              isExpanded: true,
                              hint: Text(
                                "num",
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
                              items: numPlayersList.map(
                                (e) {
                                  return DropdownMenuItem<String>(value: e.toString(), child: Text(e.toString()));
                                },
                              ).toList(),
                              validator: (value) {
                                if (value == null || value == "") {
                                  return 'Select number of players';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _numPlayers = int.parse(value.toString());
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
                        height: 16,
                      ),
                      Row(
                        children: [
                          const Text("STATION NUMBER: "),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: DropdownButtonFormField2<String>(
                              isExpanded: true,
                              hint: Text(
                                "num",
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
                              items: stationNumberList.map(
                                (e) {
                                  return DropdownMenuItem<String>(value: e.toString(), child: Text(e.toString()));
                                },
                              ).toList(),
                              validator: (value) {
                                if (value == null || value == "") {
                                  return 'Select station number';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _stationNum = int.parse(value.toString());
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
                        height: 16,
                      ),
                      if (_numPlayers != 0 && _stationNum != 0)
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _numPlayers,
                          itemBuilder: (context, index) {
                            return PlayerChip(
                              station: _stationNum,
                            );
                          },
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
