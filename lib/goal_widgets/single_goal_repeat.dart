import 'package:achivment_game/goal_widgets/custom_days.dart';
import 'package:flutter/material.dart';
import 'package:achivment_game/constants.dart';
import 'package:achivment_game/models/goal_class.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:achivment_game/models/golas_list_class.dart';

class SingleGoalRepeatCard extends StatelessWidget {
  final int goalIndex;

  SingleGoalRepeatCard({this.goalIndex});

  @override
  Widget build(BuildContext context) {
    Goal goal =
        Provider.of<GoalsListClass>(context, listen: false).goals[goalIndex];
    String days() {
      String s = '';
      List list = Provider.of<GoalsListClass>(context, listen: false)
          .getCustomRepeat(goalIndex);
      for (Days days in list) {
        if (days.index != 8) {
          s += kListOfDaysName[days.index];
          s += ', ';
        }
      }
      return s;
    }

    Widget _getRepeatText() {
      if (goal.repeat == Repeat.daily) {
        return Text(
          'Repeat: daily',
          style: kTextStyleBlue,
        );
      } else if (goal.repeat == Repeat.weekly) {
//        String currentDay = DateFormat('EEEE').format(DateTime.now());
        return Text(
          'Repeat weekly on: ${days().substring(0, days().length - 2)}',
          style: kTextStyleBlue,
        );
      } else {
        return const Text('Repeat');
      }
    }

    void updateReminder() {
      if (Provider.of<GoalsListClass>(context, listen: false)
              .goals[goalIndex]
              .reminder ==
          Reminder.nothingChosen) {
        Future.delayed(Duration(milliseconds: 200)).then((value) {
          Provider.of<GoalsListClass>(context, listen: false)
              .updateReminder(Reminder.Morning, null, goalIndex);
        });
      }
    }

    Future<void> showCustomRepeatDialog() async {
      List<Days> listOfDays = [];
      for (Days day in goal.customRepeat) {
        listOfDays.add(Days.values[day.index]);
      }
      await showDialog(
        context: context,
        child: CustomDay(
            onPressed: (List listOfDays) {
              //
              if (listOfDays.length > 0) {
                Provider.of<GoalsListClass>(context, listen: false)
                    .updateRepeat(Repeat.weekly, listOfDays, goalIndex);
                updateReminder();
              }
            },
            list: listOfDays),
      );
    }

    void onSelected(Repeat repeat) async {
      try {
        if (repeat != Repeat.weekly) {
          List<Days> listOfDays = [];
          Provider.of<GoalsListClass>(context, listen: false)
              .updateRepeat(repeat, listOfDays, goalIndex);
        } else {
          //obviously the user has chosen the custom option
          await showCustomRepeatDialog();
        }
      } finally {
        //forcing the user to have reminder data
        //checking that is there no repeat data
        if (repeat == Repeat.daily) {
          updateReminder();
        } else if (goal.customRepeat.length > 0) {
          updateReminder();
        }
      }
    }

    void removeData() {
      List<Days> listOfDays = [];
      Provider.of<GoalsListClass>(context, listen: false)
          .updateRepeat(Repeat.nothingChosen, listOfDays, goalIndex);
      //removing reminder data
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Provider.of<GoalsListClass>(context, listen: false)
            .updateReminder(Reminder.nothingChosen, null, goalIndex);
      });
    }

    print('goal.repeat ${goal.repeat} ${goal.customRepeat}');
    print('goal.reminder ${goal.reminder} ${goal.customTime}');
    return PopupMenuButton<Repeat>(
      onSelected: onSelected,
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: k20RoundedRectangleBorder,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ListTile(
            leading: GestureDetector(
              //removing data
              onTap: removeData,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: const Icon(
                  Icons.clear,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
            trailing: FittedBox(
              child: Icon(
                Icons.repeat,
                color: goal.repeat == Repeat.nothingChosen
                    ? Colors.black54
                    : Colors.blue,
                size: 30,
              ),
            ),
            title: _getRepeatText(),
          ),
        ),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Repeat>>[
        const PopupMenuItem<Repeat>(
          value: Repeat.daily,
          child: Text('daily'),
        ),
        const PopupMenuItem<Repeat>(
          value: Repeat.weekly,
          child: Text('Weekly'),
        ),
      ],
      offset: Offset(1, -110),
    );
  }
}
