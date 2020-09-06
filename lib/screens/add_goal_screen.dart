import 'package:achivment_game/goal_widgets/reminder_menu.dart';
import 'package:achivment_game/goal_widgets/repeat_menu.dart';
import 'package:achivment_game/models/goal_class.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddGoalScreen extends StatefulWidget {
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

enum WhyFarther { harder, smarter, selfStarter }

class _AddGoalScreenState extends State<AddGoalScreen> {
  TextEditingController _textEditingController;

  FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  void repeatData() {
    _focusNode.requestFocus(FocusNode());
  }

  void getReminder() {
    // open the focus to the same textfield
    _focusNode.requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).viewInsets.bottom);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool changeScrollDirection = Provider.of<Goal>(context).repeat ==
            Repeat.nothingChosen
        ? false
        : Provider.of<Goal>(context).repeat != Repeat.weekly
            ? false
            : Provider.of<Goal>(context).customRepeat.length > 1 ? true : false;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.57,
      maxChildSize: 0.7,
      minChildSize: 0.57,
      builder: (context, myScrollContrller) {
        return Container(
          color: const Color(0xFF767676),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              controller: myScrollContrller,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        autofocus: true,
                        focusNode: _focusNode,
                        controller: _textEditingController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Add a goal',
                        ),
                        onSubmitted: (_) async {
                          // add a goal
                          //check the string that it is not bunch of spaces
                          bool empty = false;
                          for (int i = 0;
                              i < _textEditingController.text.length;
                              i++) {
                            if (_textEditingController.text[i] == ' ') {
                              empty = true;
                            } else {
                              empty = false;
                              break;
                            }
                          }
                          if (_textEditingController.text.isNotEmpty &&
                              !empty) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Provider.of<GoalsListClass>(context, listen: false)
                                .addGoal(
                              _textEditingController.text,
                              Provider.of<Goal>(context, listen: false).repeat,
                              Provider.of<Goal>(context, listen: false)
                                  .reminder,
                              Provider.of<Goal>(context, listen: false)
                                  .customRepeat,
                              Provider.of<Goal>(context, listen: false)
                                  .customTime,
                            );
                          }
                          //clear the data
                          _textEditingController.clear();
                          Provider.of<Goal>(context, listen: false).repeat =
                              Repeat.nothingChosen;
                          Provider.of<Goal>(context, listen: false).reminder =
                              Reminder.nothingChosen;

                          Provider.of<Goal>(context, listen: false)
                              .customRepeat = [];
                          Provider.of<Goal>(context, listen: false).customTime =
                              null;
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            width: screenWidth * 0.04,
                          ),
                          ReminderMenu(
                            getReminderData: getReminder,
//                        reminderMeaning: _reminderMeaning,
//                        timeOfDay: _pickedTime,
                          ),
                          SizedBox(
                            width: changeScrollDirection
                                ? screenWidth * 0.04
                                : screenWidth * 0.09,
                          ),
                          RepeatMenu(
                            getRepeatData: repeatData,
//                        repeatMeaning: _repeatMeaning,
                          ),
                          SizedBox(
                            width: screenWidth * 0.04,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
