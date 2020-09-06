import 'package:flutter/material.dart';
import 'package:achivment_game/constants.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:provider/provider.dart';
import 'package:achivment_game/models/goal_class.dart';

class SingleGoalReminderCard extends StatelessWidget {
  final int goalIndex;

  SingleGoalReminderCard({this.goalIndex});

  @override
  Widget build(BuildContext context) {
    Goal goal =
        Provider.of<GoalsListClass>(context, listen: false).goals[goalIndex];
    TimeOfDay _pickedTime;

    Future<void> reminderShowTimePicker() async {
      _pickedTime = await showTimePicker(
        context: context,
        initialTime:
            goal.customTime != null ? goal.customTime : TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light(),
            child: child,
          );
        },
      );
    }

    void updateRepeat() {
      if (Provider.of<GoalsListClass>(context, listen: false)
              .goals[goalIndex]
              .repeat ==
          Repeat.nothingChosen) {
        print('asdasd');
        Future.delayed(Duration(milliseconds: 200)).then((value) {
          int dayNum = DateTime.now().weekday;
          List<Days> listOfDays = [Days.values[dayNum]];
          Provider.of<GoalsListClass>(context, listen: false)
              .updateRepeat(Repeat.weekly, listOfDays, goalIndex);
        });
      }
    }

    void getReminder(Reminder reminder) async {
      try {
        if (reminder == Reminder.pickTime) {
          await reminderShowTimePicker();
          // make sure that the user has acually picked a time
          if (_pickedTime != null) {
            Provider.of<GoalsListClass>(context, listen: false)
                .updateReminder(Reminder.pickTime, _pickedTime, goalIndex);
          }
        } else {
          Provider.of<GoalsListClass>(context, listen: false)
              .updateReminder(reminder, null, goalIndex);
        }
      } finally {
        //forcing the user to have repeat data
        //adding the current day to the customRepeat
        //checking there is no repeat data and the pickedTime is not null
        if (reminder == Reminder.pickTime) {
          if (_pickedTime != null) {
            updateRepeat();
          } else {}
        } else {
          updateRepeat();
        }
      }
    }

    Widget getText() {
      if (goal.reminder == Reminder.pickTime && goal.customTime != null) {
        DayPeriod s = goal.customTime.period;
        return Text(
          'Remind me at ${goal.customTime.hour}:${goal.customTime.minute}'
          '${s == DayPeriod.am ? ' am' : ''}',
          style: kTextStyleBlue,
        );
      } else if (goal.reminder == Reminder.Morning) {
        return Text(
          'Remind me: Morning 8:00',
          style: kTextStyleBlue,
        );
      } else if (goal.reminder == Reminder.Afternoon) {
        return Text(
          'Remind me: Afternoon 13:00',
          style: kTextStyleBlue,
        );
      } else if (goal.reminder == Reminder.Night) {
        return Text(
          'Remind me: Night 20:00',
          style: kTextStyleBlue,
        );
      } else {
        goal.reminder = Reminder.nothingChosen;
        return Text('Remind me');
      }
    }

    void removeData() {
      List<Days> listOfDays = [];
      Provider.of<GoalsListClass>(context, listen: false)
          .updateReminder(Reminder.nothingChosen, null, goalIndex);
      //removing repeat data
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Provider.of<GoalsListClass>(context, listen: false)
            .updateRepeat(Repeat.nothingChosen, listOfDays, goalIndex);
      });
    }

    return PopupMenuButton<Reminder>(
      onSelected: getReminder,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        shape: k20RoundedRectangleBorder,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ListTile(
            leading: GestureDetector(
              onTap: removeData,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Icon(
                  Icons.clear,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
            trailing: FittedBox(
              child: Icon(
                Icons.access_time,
                color: goal.reminder == Reminder.nothingChosen
                    ? Colors.black54
                    : Colors.blue,
                size: 30,
              ),
            ),
            title: getText(),
          ),
        ),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Reminder>>[
        const PopupMenuItem<Reminder>(
          value: Reminder.Morning,
          child: Text('Morning 8:00'),
        ),
        const PopupMenuItem<Reminder>(
          value: Reminder.Afternoon,
          child: Text('Afternoon 13:00'),
        ),
        const PopupMenuItem<Reminder>(
          value: Reminder.Night,
          child: Text('Night 20:00'),
        ),
        const PopupMenuItem<Reminder>(
          value: Reminder.pickTime,
          child: Text('Pick a time'),
        ),
      ],
      offset: Offset(1, -162),
    );
  }
}
