import 'package:achivment_game/models/goal_class.dart';
import 'package:achivment_game/models/notification_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsManager {
  static List<int> allTheNotificationId = [];
  static List<Time> listOfSpecificTime = [
    Time(8, 0, 0),
    Time(13, 0, 0),
    Time(20, 0, 0),
  ];
  static Future<void> showNotification(Goal goal) async {
    //there are only 3 options
    //1. there is no notification defined
    if (goal.repeat != Repeat.nothingChosen) {
      //id there is a one then..
      if (goal.repeat == Repeat.weekly) {
        await _showWeeklyNotification(goal);
      } else {
        //that means the notification is daily
        await _showDailyNotification(goal);
      }
    }
  }

  static Future<void> _showDailyNotification(Goal goal) async {
    //either it is daily with custom time or daile with regular time
    if (goal.reminder == Reminder.pickTime) {
      if (_interpretTime(goal.customTime) != null) {
        await notificationPlugin.showDailyAtTime(
          goal.permanentId,
          goal.name,
          _interpretTime(goal.customTime),
        );
      }
    } else {
      //regular time is chosen
      await notificationPlugin.showDailyAtTime(
        goal.permanentId,
        goal.name,
        listOfSpecificTime[goal.reminder.index],
      );
    }
  }

  static Future<void> _showWeeklyNotification(Goal goal) async {
    List<int> listOfWeekDayNum = _getNumberOfDays(goal.customRepeat);
    //either it is weekly with custom time or weekly with regular time
    //if user has chosen all the days then
    if (listOfWeekDayNum.length == 6) {
      _showDailyNotification(goal);
    } else {
      if (goal.reminder == Reminder.pickTime) {
        if (_interpretTime(goal.customTime) != null) {
          for (int numberOfTheWeekDay in listOfWeekDayNum) {
            await notificationPlugin.showWeeklyAtDayTime(
              _interpretIdForWeekNotification(
                  goal.permanentId, numberOfTheWeekDay),
              goal.name,
              //this is correct use of Day because values starts from index =0
              //but the value of this index is 1 ~!!!!
              Day.values[numberOfTheWeekDay],
              _interpretTime(goal.customTime),
            );
          }
        }
      } else {
        //time is one of there options
        for (int numberOfTheWeekDay in listOfWeekDayNum) {
          await notificationPlugin.showWeeklyAtDayTime(
            _interpretIdForWeekNotification(
                goal.permanentId, numberOfTheWeekDay),
            goal.name,
            Day.values[numberOfTheWeekDay],
            listOfSpecificTime[goal.reminder.index],
          );
        }
      }
    }
  }

  static Future<void> cancelNotification(Goal goal) async {
    //either this goal has weekly one or daily one
    if (goal.repeat == Repeat.weekly) {
      await _cancelWeeklyNotification(goal);
    } else {
      //has a daily notification
      await _cancelDailyNotification(goal);
    }
  }

  static Future<void> _cancelDailyNotification(Goal goal) async {
    if (goal.repeat == Repeat.daily) {
      await notificationPlugin.cancelNotification(
        goal.permanentId,
      );
    }
  }

  static Future<void> _cancelWeeklyNotification(Goal goal) async {
    List<int> listOfWeekDayNum = _getNumberOfDays(goal.customRepeat);
    if (listOfWeekDayNum.length == 6) {
      //means that was added like a daily notification
      await notificationPlugin.cancelNotification(
        goal.permanentId,
      );
    } else {
      //regular weekly notification
      for (int weekDay in listOfWeekDayNum) {
        await notificationPlugin.cancelNotification(
          _interpretIdForWeekNotification(goal.permanentId, weekDay),
        );
      }
    }
  }

  static Future<void> cancelAllNotification() async {
    await notificationPlugin.cancelAllNotification();
  }

  static List<int> _getNumberOfDays(List<Days> days) {
    List<int> list = [];
    for (Days day in days) {
      list.add(day.index);
    }
    return list;
  }

  static Time _interpretTime(TimeOfDay timeOfDay) {
    if (timeOfDay != null) {
      Time time = Time(timeOfDay.hour, timeOfDay.minute, 10);
      return time;
    } else {
      return null;
    }
  }

  static int _interpretIdForWeekNotification(int goalPermenantId, int weekDay) {
    String s = goalPermenantId.toString();
    s += weekDay.toString();
    print(int.parse(s));
    return int.parse(s);
  }
}
