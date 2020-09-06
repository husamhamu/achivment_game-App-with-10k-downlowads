import 'package:achivment_game/goal_widgets/clear_widget.dart';
import 'package:achivment_game/models/goal_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReminderMenu extends StatelessWidget {
  final Function getReminderData;
//  final String reminderMeaning;
//  final TimeOfDay timeOfDay;
  ReminderMenu({
    @required this.getReminderData,
//    @required this.reminderMeaning,
//    @required this.timeOfDay,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // we have initialize the provider goal so it is ok
    Goal goal = Provider.of<Goal>(context, listen: false);
    Reminder _reminder = Provider.of<Goal>(context, listen: false).reminder;
    TimeOfDay _pickedTime;
    // getting the reminder data
    void getReminder(Reminder result) async {
      if (result == Reminder.pickTime) {
        FocusScope.of(context).requestFocus(FocusNode());
        _pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData.light(),
              child: child,
            );
          },
        );
        // make sure that the user has acually picked a time
        if (_pickedTime != null) {
          Provider.of<Goal>(context, listen: false).reminder =
              Reminder.pickTime;
          Provider.of<Goal>(context, listen: false).customTime = _pickedTime;
        }
      } else {
        Provider.of<Goal>(context, listen: false).reminder = result;
        Provider.of<Goal>(context, listen: false).customTime = null;
      }
      // a call back to the AddGoalScreen method
      getReminderData();
    }

//    String laterAt() {
////      DateTime now = DateTime.now();
////      DateTime now = DateTime(now2.year, now2.month, now2.day, 15, 5);
//      final DateTime now = DateTime.now();
//      if (now.isAfter(kLaterOn6AM) & !now.isAfter(kLaterOn9AM)) {
//        return 'at 9:00';
//      } else if (now.isAfter(kLaterOn9AM) & !now.isAfter(kLaterOn12AM)) {
//        return 'at 12:00';
//      } else if (now.isAfter(kLaterOn12AM) & !now.isAfter(kLaterOn16PM)) {
//        return 'at 16:00';
//      } else if (now.isAfter(kLaterOn16PM) & !now.isAfter(kLaterOn21PM)) {
//        return 'at 21:00';
//      } else {
//        return '';
//      }
//    }

    void updateRepeat() {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        if (Provider.of<Goal>(context, listen: false).repeat ==
            Repeat.nothingChosen) {
          Provider.of<Goal>(context, listen: false).repeat = Repeat.weekly;
          //adding the current day to the customRepeat
          int dayNum = DateTime.now().weekday;
          List<Days> list = [Days.values[dayNum]];
          Provider.of<Goal>(context, listen: false).customRepeat = list;
        }
      });
    }

    Widget reminderChild;
    if (Provider.of<Goal>(context).reminder == Reminder.nothingChosen) {
      reminderChild = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(Icons.alarm),
          SizedBox(width: 5),
          const Text(
            'Remind me',
            style: TextStyle(fontSize: 16),
          ),
        ],
      );
    } else {
      DayPeriod dayPeriod;
      if (goal.customTime != null) {
        dayPeriod = goal.customTime.period;
      }
      updateRepeat();
      reminderChild = Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Icon(Icons.alarm),
            const SizedBox(width: 5),
            Text(
              Provider.of<Goal>(context).reminder == Reminder.Morning
                  ? 'Morning 8:00'
                  : Provider.of<Goal>(context).reminder == Reminder.Afternoon
                      ? 'Afternoon 13:00'
                      : Provider.of<Goal>(context).reminder == Reminder.Night
                          ? 'Night 20:00'
                          : 'At ${goal.customTime.hour}:${goal.customTime.minute}'
                              '${dayPeriod == DayPeriod.am ? ' am' : ''}',
              style: const TextStyle(fontSize: 16),
            ),
//        print(goal.customTime);
//        DayPeriod s = goal.customTime.period;
//        return Text(
//      'Remind me at ${goal.customTime.hour}:${goal.customTime.minute}'
//        '${s == DayPeriod.am ? ' am' : ''}',
            const SizedBox(width: 5),
            CleanWidget(
              onTap: () {
//                    getRepeatData('Repeat', Repeat.nothingChosen, _listOfDays);
                Provider.of<Goal>(context, listen: false).reminder =
                    Reminder.nothingChosen;
                Provider.of<Goal>(context, listen: false).customTime = null;
                //cancel the repeat data
                Provider.of<Goal>(context, listen: false).repeat =
                    Repeat.nothingChosen;
                Provider.of<Goal>(context, listen: false).customRepeat = [];
              },
            ),
          ],
        ),
      );
    }

    return PopupMenuButton<Reminder>(
      onSelected: getReminder,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          // scale
          return ScaleTransition(
            child: child,
            scale: animation,
          );
        },
        child: reminderChild,
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
      offset: Offset(-30, -200),
    );
  }
}
