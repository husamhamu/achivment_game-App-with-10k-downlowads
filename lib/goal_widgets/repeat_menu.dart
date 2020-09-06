import 'package:achivment_game/constants.dart';
import 'package:achivment_game/goal_widgets/clear_widget.dart';
import 'package:achivment_game/goal_widgets/custom_days.dart';
import 'package:achivment_game/models/goal_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RepeatMenu extends StatelessWidget {
  final Function getRepeatData;
  RepeatMenu({
    @required this.getRepeatData,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void repeatData(Repeat repeatData) async {
      List<Days> listOfDays = [];
      for (Days day in Provider.of<Goal>(context, listen: false).customRepeat) {
        listOfDays.add(Days.values[day.index]);
      }
      // set the repeat property
      if (repeatData != Repeat.weekly) {
        Provider.of<Goal>(context, listen: false).repeat = repeatData;
        Provider.of<Goal>(context, listen: false).customRepeat = [];
      } else {
        // closing the  keyboard before
        FocusScope.of(context).requestFocus(FocusNode());
        //showing the dialog
        await showDialog(
          context: context,
          child: CustomDay(
            list: listOfDays,
            onPressed: (List list) {
              if (list.length > 0) {
                Provider.of<Goal>(context, listen: false).repeat =
                    Repeat.weekly;
                Provider.of<Goal>(context, listen: false).customRepeat = list;
              }
            },
          ),
        );
      }
      // a tiny call back to the AddGoalScreen method
      getRepeatData();
    }

    void updateReminder() {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        if (Provider.of<Goal>(context, listen: false).reminder ==
            Reminder.nothingChosen) {
          Provider.of<Goal>(context, listen: false).reminder = Reminder.Morning;
        }
      });
    }

    String days() {
      String s = '';
      List list = Provider.of<Goal>(context, listen: false).customRepeat;
      for (Days days in list) {
        if (days.index != 8) {
          s += kListOfDaysName[days.index];
          s += ', ';
        }
      }
      return s;
    }

    String getWeeklyDays() {
      if (Provider.of<Goal>(context, listen: false).customRepeat.length > 0) {
        if (Provider.of<Goal>(context, listen: false).customRepeat.length ==
            1) {
          return days();
        } else {
          return days().substring(0, 15) + '..';
          // return days();
        }
      }
    }

    Widget repeatChild;
    if (Provider.of<Goal>(context).repeat == Repeat.nothingChosen) {
      repeatChild = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(Icons.repeat),
          SizedBox(width: 5),
          const Text(
            'Repeat',
            style: TextStyle(fontSize: 16),
          ),
        ],
      );
    } else {
      updateReminder();
      repeatChild = Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Icon(Icons.repeat),
            const SizedBox(width: 5),
            Text(
              Provider.of<Goal>(context).repeat == Repeat.daily
                  ? 'daily'
                  : 'weekly: ${getWeeklyDays()}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 5),
            CleanWidget(
              onTap: () {
//                    getRepeatData('Repeat', Repeat.nothingChosen, _listOfDays);
                Provider.of<Goal>(context, listen: false).repeat =
                    Repeat.nothingChosen;
                Provider.of<Goal>(context, listen: false).customRepeat = [];
                //cancel the reminder data
                Provider.of<Goal>(context, listen: false).reminder =
                    Reminder.nothingChosen;
                Provider.of<Goal>(context, listen: false).customTime = null;
              },
            ),
          ],
        ),
      );
    }

    return RepeatPopupMenu(
      child: repeatChild,
      onSelected: repeatData,
    );
  }
}

class RepeatPopupMenu extends StatelessWidget {
  Widget child;
  Function onSelected;

  RepeatPopupMenu({this.child, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Repeat>(
      onSelected: onSelected,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            child: child,
            scale: animation,
          );
        },
        child: child,
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
      offset: Offset(100, -115),
    );
  }
}
