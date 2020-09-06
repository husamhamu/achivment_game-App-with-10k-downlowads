import 'package:achivment_game/helpers/db_helper.dart';
import 'package:achivment_game/models/goal_class.dart';
import 'package:achivment_game/models/notification_plugin.dart';
import 'package:achivment_game/models/notifications_manager.dart';
import 'package:achivment_game/models/step_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum Moving {
  forwards,
  backwards,
}

class GoalsListClass with ChangeNotifier {
  List<Goal> _goals;
  int _totalPointsLeft = 1000;
  int _totalAchievement = 0;
  bool _updateName = false;
  int permenantGoalId = 1;
  //
  // <key: weekNumber , value: weekAchievement>

//  Map<int, int> weekNumAndAchievement = {};

  //Map<weekNum, Map<goalIndex,percentOfAchievement> >
  Map<int, Map<int, double>> weekNumAndGoalIndex = {};

  GoalsListClass() {
    _goals = [];
  }

  static bool checkString(String string) {
    //check the string that it is not bunch of spaces
    bool empty = false;
    for (int i = 0; i < string.length; i++) {
      if (string[i] == ' ') {
        empty = true;
      } else {
        empty = false;
        break;
      }
    }
    if (string.isNotEmpty && !empty) {
      return true;
    } else {
      return false;
    }
  }

// we will have 6 different ways to add a goal !!
  // but that would be quit painful
  // so if nothing is chosen by the user just pass that
  // like Reminder.nothingChosen
  void addGoal(
    String name,
    Repeat repeat,
    Reminder reminder,
    List<Days> customRepeat,
    TimeOfDay customDateTime,
  ) async {
    if (checkString(name)) {
      Goal goal = Goal(_goals.length, permenantGoalId, name, repeat, reminder,
          customRepeat, customDateTime);
      _goals.add(goal);
      await DBHelper.insertGoal(goal);
      NotificationsManager.showNotification(goal);
      int count = await notificationPlugin.getPendingNotificationCount();
      print('count $count');

      permenantGoalId++;
    }
    notifyListeners();
  }

  Goal getTheLastAddedGoal() {
    if (_goals != null) {
      if (_goals.length > 0) {
        return _goals[_goals.length - 1];
      }
    }
    return null;
  }

  Future<void> _cancelNotification(int goalIndex, [Goal goal]) async {
    //this method should be called before** updating the repeat data
    if (_goals[goalIndex].repeat == Repeat.nothingChosen) {
      //there was no notification to cancel
      //nothing
    } else {
      //means there is a notification
      //either we are going to cancel it or we are going to add it
      await NotificationsManager.cancelNotification(_goals[goalIndex]);
      // if (repeat == Repeat.nothingChosen) {
      //
      // } else {
      //   //we need to add it
      //   //and it is not the job of this function
      // }
    }
  }

  Future<void> _addNotification(int goalIndex) async {
    //this method should be called after** updating the repeat data and reminder data
    if (_goals[goalIndex].repeat == Repeat.nothingChosen) {
      //noting
    } else {
      //need to add a new one
      await NotificationsManager.showNotification(_goals[goalIndex]);
    }
  }

  void updateRepeat(
      Repeat repeatDate, List<Days> customRepeat, int goalIndex) async {
    //user either pick a customRepeat or a normal repeat or nothing
    //we know for sure that canceling repeat cancel the reminder
    //so we only need to cancel the notification here
    ///but if we update the reminder and there were allready repeat data then we need to make
    ///an update to the notification to have the new chosen time
    //also canceling might take a bit of tim and we want to cancel notification
    // and then add the new one
    await _cancelNotification(goalIndex).then((value) async {
      try {
        if (repeatDate != Repeat.weekly) {
          _goals[goalIndex].repeat = repeatDate; //
          //don't forget to initialize it again!
          _goals[goalIndex].customRepeat = [];
        } else {
          _goals[goalIndex].repeat = Repeat.weekly;
          _goals[goalIndex].customRepeat = customRepeat;
        }
      } finally {
        await DBHelper.updateRepeat(_goals[goalIndex]);
        //need to add the new one
        //we will wait to be sure we finished canceling the notification
        Future.delayed(Duration(milliseconds: 500)).then((value) async {
          //check the function
          print('reminder has been updated ${_goals[goalIndex].reminder}');
          await _addNotification(goalIndex);
        });
      }

      notifyListeners();
    });
  }

  int numberOfTheDoneSteps(int goalIndex) {
    int num = 0;
    for (StepClass step in _goals[goalIndex].steps) {
      if (step.isDone) {
        num++;
      }
    }
    return num;
  }

  void updateReminder(
      Reminder reminder, TimeOfDay customReminder, int goalIndex) async {
    // user can either pick a customReminder(time) or a regular reminder or nothing
    //before we update we check weather if this an update to the reminder but not to the repeat
    ///if goal.reminder was't Reminder.nothingChosen

    if (_goals[goalIndex].reminder != Reminder.nothingChosen) {
      ///and the passed reminder is not Reminder.nothingChosen
      if (reminder != Reminder.nothingChosen) {
        //then we need to cancel the current notification
        await _cancelNotification(goalIndex).then((value) async {
          print('das');
          try {
            if (reminder != Reminder.pickTime) {
              _goals[goalIndex].reminder = reminder;
              _goals[goalIndex].customTime = null;
            } else {
              _goals[goalIndex].customTime = customReminder;
              _goals[goalIndex].reminder = Reminder.pickTime;
            }
            notifyListeners();
          } finally {
            await DBHelper.updateReminder(_goals[goalIndex]);
            await _addNotification(goalIndex);
          }
        });
        return;
      }
    }

    try {
      if (reminder != Reminder.pickTime) {
        _goals[goalIndex].reminder = reminder;
        _goals[goalIndex].customTime = null;
      } else {
        _goals[goalIndex].customTime = customReminder;
        _goals[goalIndex].reminder = Reminder.pickTime;
      }
      notifyListeners();
    } finally {
      await DBHelper.updateReminder(_goals[goalIndex]);
    }
  }

  void checkBox(int index) async {
//    print('from goal_class index: $index  < ${_goals.length}');
    if (index <= _goals.length) {
      _goals[index].checkGoal();
      await DBHelper.checkGoal(_goals[index]);
    }
    notifyListeners();
  }

  void deleteGoal(int goalIndex, int numberOfTheCurrentWeek) async {
    Goal goal = _goals[goalIndex];
    int permanentId = _goals[goalIndex].permanentId;
    print('goalIndex $goalIndex');
    try {
      // Future.delayed(Duration(milliseconds: 100)).then((value) async {
      if (goalIndex < _goals.length) {
        if (goalIndex != 0 && goalIndex != _goals.length - 1) {
          _goals.remove(_goals[goalIndex]);
          //updating the id
          updateGoalsId();
          notifyListeners();
          await DBHelper.deleteGoal(goalIndex);
        } else {
          Future.delayed(Duration(milliseconds: 800)).then((value) async {
            _goals.remove(_goals[goalIndex]);
            //updating the id
            updateGoalsId();
            notifyListeners();
            await DBHelper.deleteGoal(goalIndex);
          });
        }
      }
      // });
    } finally {
      ///canceling notification
      await NotificationsManager.cancelNotification(goal);

      for (Goal goal in _goals) {
        if (goal.id > goalIndex) {
          goal.id = goal.id - 1;
        }
      }
      //we need to delete the related data  in the: weekNumAndGoalIndex map
      if (numberOfTheCurrentWeek > 0) {
        print('weekNumAndGoalIndex $weekNumAndGoalIndex');
        for (int i = 1; i <= numberOfTheCurrentWeek; i++) {
          if (weekNumAndGoalIndex.containsKey(i)) {
            print(weekNumAndGoalIndex[i].containsKey(permanentId));
            if (weekNumAndGoalIndex[i].containsKey(permanentId)) {
              weekNumAndGoalIndex[i][permanentId] = 0.0;
              //we don't need to do this because it will be however updated
              await DBHelper.creatGoalList(
                  i, weekNumAndGoalIndex[i], permenantGoalId);
            }
          }
        }
      }
    }
  }

  void updateGoalName(int goalIndex, String newName) async {
    if (goalIndex < _goals.length) {
      if (checkString(newName)) {
        _goals[goalIndex].name = newName;
        await DBHelper.updateGoalName(_goals[goalIndex]);
        notifyListeners();
      }
    }
  }

  bool checkPermenantIdexisting(int permanentId) {
    for (Goal goal in _goals) {
      if (goal.permanentId == permanentId) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool get updateName => _updateName;

  void updateNameBoolean() {
    _updateName = !_updateName;
    notifyListeners();
  }

  void updateStepName(int goalIndex, int stepIndex, String newName) async {
    if (goalIndex < _goals.length) {
      if (checkString(newName)) {
        _goals[goalIndex].updateStepName(stepIndex, newName);
        await DBHelper.insertStep(_goals[goalIndex].steps, goalIndex);
        _goals[goalIndex].updateStepNameBoolean(stepIndex, false);
        notifyListeners();
      } else {
        // updateStepNameBoolean(goalIndex, stepIndex, false);
      }
    }
  }

  void updateStepNameBoolean(int goalIndex, int stepIndex, bool value) {
    _goals[goalIndex].updateStepNameBoolean(stepIndex, value);
    notifyListeners();
  }

  bool stepNameBoolean(int goalIndex, int stepIndex) {
    return _goals[goalIndex].steps[stepIndex].updateName;
  }

  void allStepNameBoolean(int goalIndex) {
    _goals[goalIndex].updateAllStepNameBoolean(false);
  }

  String getStepName(int goalIndex, int stepIndex) {
    return _goals[goalIndex].steps[stepIndex].name;
  }

  void deleteStep(int goalIndex, int stepIndex) async {
    if (goalIndex < _goals.length) {
      if (stepIndex < _goals[goalIndex].steps.length) {
        _goals[goalIndex].deleteStep(stepIndex);
        await DBHelper.insertStep(_goals[goalIndex].steps, goalIndex);
        notifyListeners();
      }
    }
  }

  List<Goal> get goals => List.unmodifiable(_goals);

  int getLength() {
    return _goals.length;
  }

  // points

  void addStep(int goalIndex, String name) async {
    print(goalIndex);
    _goals[goalIndex].addStep(name);
    await DBHelper.insertStep(_goals[goalIndex].steps, goalIndex);
    notifyListeners();
  }

  void checkStep(int goalIndex, int stepIndex) async {
    _goals[goalIndex].checkStep(stepIndex);
    await DBHelper.insertStep(_goals[goalIndex].steps, goalIndex);
    notifyListeners();
  }

  void updatStepPosition(int goalIndex, int oldIndex, int newIndex) async {
    _goals[goalIndex].updateStepPositino(oldIndex, newIndex);
    Future.delayed(Duration(milliseconds: 1000)).then((value) async {
      await DBHelper.insertStep(_goals[goalIndex].steps, goalIndex);
    });
    notifyListeners();
  }

  //no longer supported
  void updateGoalPosition(int oldIndex, int newIndex) async {
    print('oldIndex $oldIndex, newIndex $newIndex');
    //when we take the element from bottom to top it behave
    //correctly(index starts from 0)
    // otherwise the newIndex is +1 than it than it should be

    if (oldIndex > newIndex) {
//      Goal goalAtTheNewIndex = _goals[newIndex];
      Goal goal = _goals[oldIndex];
      _goals.removeAt(oldIndex);
      _goals.insert(newIndex, goal);
      //update the id of the goals
      updateGoalsId();
      Future.delayed(Duration(milliseconds: 400)).then((value) async {
        await DBHelper.updateGoalPosition(goal, oldIndex, newIndex);
      });
      //we just reverse the old and the newIndex because we updated in the list allread
    } else if (newIndex > oldIndex) {
      newIndex = newIndex - 1;
      //and then updating the position
//      Goal goalAtTheNewIndex = _goals[newIndex];
      Goal goal = _goals[oldIndex];
      _goals.removeAt(oldIndex);
      _goals.insert(newIndex, goal);
      //update the id of the goals
      updateGoalsId();
      Future.delayed(Duration(milliseconds: 400)).then((value) async {
        await DBHelper.updateGoalPosition(goal, oldIndex, newIndex);
      });
    }

    notifyListeners();
  }

  void updateGoalsId() {
    for (int i = 0; i < _goals.length; i++) {
      _goals[i].id = i;
    }
  }

  Future<int> getTotalPoints(int points, int goalIndex, bool changeDB) async {
    // the left points are calcuated useing getMaxPoints - points
    if (points < 1000 && goalIndex < _goals.length) {
      _totalPointsLeft = getMaxPointLeft(goalIndex) - points;

      //set the points of the current goal
      _goals[goalIndex].points = points;
      //we trigger this method if the points has changed to change points in the database
      //and to make sense of the previous achievement
      if (changeDB) {
        await DBHelper.updateGoalPoints(_goals[goalIndex]);
      }
    }
    notifyListeners();
    return _totalPointsLeft;
  }

  int getMaxPointLeft(int index) {
    // the max left points should not include the current goal points
    int max = 0;
    for (int i = 0; i < _goals.length; i++) {
      if (i != index) {
        max += _goals[i].points;
      }
    }
    int max1 = 1000 - max;
//    notifyListeners();
    return max1;
  }

  int get totalPoints => _totalPointsLeft;
  // these method is used to get the UI update when the app lounches for the first time
  int get initialTotalPoints {
    int i = 1000;
    if (_goals != null) {
      for (Goal goal in _goals) {
        i -= goal.points;
      }
    }
    return i;
  }

  void updateAchievement(
      int goalIndex, int weekNum, int point, bool changeDB) async {
    //remember achivment will hold a percentage
    if (weekNum == 1) {
      _goals[goalIndex].achievement = (point / _goals[goalIndex].points);
      _updateTotalAchievement();
      _updateWeekAchievement(weekNum, goalIndex);
      if (changeDB) {
        await DBHelper.updateAchivement(_goals[goalIndex]);
      }
    } else {
      //we will know for sure that there is
      int acvhievedPointsInPreviousWeeks = 0;
      for (int i = 1; i < weekNum; i++) {
        acvhievedPointsInPreviousWeeks +=
            getWeekAchievmentForGoal(i, goalIndex);
      }
      // if the passed points is greater then the sum of the total points that are achieved in
      //the previous weeks for this goal then we will update!
      if (point > acvhievedPointsInPreviousWeeks) {
        _goals[goalIndex].achievement = (point / _goals[goalIndex].points);
        _updateTotalAchievement();
        _updateWeekAchievement(weekNum, goalIndex);
        if (changeDB) {
          await DBHelper.updateAchivement(_goals[goalIndex]);
        }
      }
    }
    notifyListeners();
  }

  double achievedPointsExceptThisIndex(
      int goalIndex, double theNewPointsForThisIndex) {
    double achievedPointsExceptThisIndex = theNewPointsForThisIndex;
    for (int i = 0; i < _goals.length; i++) {
      if (i != goalIndex) {
        achievedPointsExceptThisIndex +=
            _goals[i].achievement * _goals[goalIndex].points;
      }
    }
    return achievedPointsExceptThisIndex;
  }

//*
  int getWeekAchievement(int weekNum) {
    int weekAchievement = 0;
    //it sounds crazy to put _goals.length but we wanna check later for the
    // existing of this goalIndex in the map
    if (_goals != null) {
      for (int i = 0; i <= permenantGoalId; i++) {
        //_goals[goalIndex].points
        //weekNumAndGoalIndex[i][i] this is holding a percent!
        //need to make sure that the key is included
        if (weekNumAndGoalIndex[weekNum] != null) {
          if (weekNumAndGoalIndex[weekNum].containsKey(i)) {
            if (_getGoalIndexDependingOnPermenantId(i) != -1) {
              int goalIndex = _getGoalIndexDependingOnPermenantId(i);
              weekAchievement +=
                  (weekNumAndGoalIndex[weekNum][i] * getGoalPoints(goalIndex))
                      .round();
            }
          }
        } else {
          weekAchievement = 0;
        }
      }
    }
    return weekAchievement;
  }

  int _getGoalIndexDependingOnPermenantId(int permanentId) {
    for (Goal goal in _goals) {
      print('goal.id ${goal.id} goal.permanentId ${goal.permanentId}');
      if (goal.permanentId == permanentId) {
        return goal.id;
      }
    }
    return -1;
  }

  int getWeekAchievmentForGoal(int weekNum, int goalIndex) {
    int weekAchievmentForGoal = 0;
    if (weekNumAndGoalIndex.containsKey(weekNum)) {
      if (weekNumAndGoalIndex[weekNum]
          .containsKey(_goals[goalIndex].permanentId)) {
        weekAchievmentForGoal =
            (weekNumAndGoalIndex[weekNum][goalIndex] * _goals[goalIndex].points)
                .round();
      }
    } else {
      print('it does not contain weekNum $weekNum');
    }
    return weekAchievmentForGoal;
  }

//*
  void _updateWeekAchievement(int weekNum, int goalIndex) async {
    //save percent of the goalAchievement
    try {
      if (weekNum == 1) {
        //check if weekNum wasn't added before!
        if (!weekNumAndGoalIndex.containsKey(weekNum)) {
          Map<int, double> map = {};
          weekNumAndGoalIndex[weekNum] = map;
          //permanentId is the key , percentage is the value
          map[_goals[goalIndex].permanentId] = _goals[goalIndex].achievement;
        } else {
          weekNumAndGoalIndex[weekNum][_goals[goalIndex].permanentId] =
              _goals[goalIndex].achievement;
          print(weekNumAndGoalIndex);
        }
      } else {
        //need to store the (percent achievement - previous percent in previous weeks)
        double previousPercentage = 0;
        double newPercentage = 0;
        for (int i = 1; i < weekNum; i++) {
          previousPercentage += (getWeekAchievmentForGoal(i, goalIndex)) /
              _goals[goalIndex].points;
        }

        double percent = goals[goalIndex].achievement;
        String s = (percent - previousPercentage).toStringAsFixed(3);
        newPercentage = double.parse(s);
        print('previousPercentage $previousPercentage');
        if (!weekNumAndGoalIndex.containsKey(weekNum)) {
          Map<int, double> map = {};
          weekNumAndGoalIndex[weekNum] = map;
          map[_goals[goalIndex].permanentId] = newPercentage;
        } else {
          weekNumAndGoalIndex[weekNum][_goals[goalIndex].permanentId] =
              newPercentage;
        }
      }
    } finally {
      await DBHelper.creatGoalList(
          weekNum, weekNumAndGoalIndex[weekNum], permenantGoalId);
      notifyListeners();
    }
  }

//*
  void _updateTotalAchievement() {
    _totalAchievement = _allTheAchievedPoints();
    print('_totalAchievement $_totalAchievement');
    notifyListeners();
  }

//*
  int _allTheAchievedPoints() {
    int achievedPoints = 0;
    for (Goal goal in _goals) {
      achievedPoints += (goal.achievement * goal.points).round();
    }
    return achievedPoints;
  }

  int getTotalAchievement(int numberOfTheCurrentWeek) {
    int total = 0;
    if (weekNumAndGoalIndex != null) {
      if (weekNumAndGoalIndex.length > 0) {
        for (int i = 1; i <= numberOfTheCurrentWeek; i++) {
          total += getWeekAchievement(i);
        }
      }
    }
    return total;
  }

  void retrievingData(List<Goal> goals, Map<int, Map<int, double>> maps) {
    _goals = [];
    _goals = goals;
    weekNumAndGoalIndex = maps;
    //we set the permenantGoalId to be equal the biggest permenantGoalId in the list +1
    //attention we won't sort the goals list!!
    List<int> list = [];
    for (Goal goal in _goals) {
      list.add(goal.permanentId);
    }
    list.sort();
    if (list.length > 0) {
      this.permenantGoalId = list[list.length - 1] + 1;
    }
    //please don't forget to notify he listeners !!!
    notifyListeners();
  }

  int achievedPointsForGoal(int goalIndex) {
    String i = (_goals[goalIndex].achievement * _goals[goalIndex].points)
        .toStringAsFixed(0);
    return int.parse(i);
  }

  int getGoalPoints(int goalIndex) {
    if (goalIndex < _goals.length) {
      int i = _goals[goalIndex].points;
      return i;
    } else {
      return 0;
    }
  }

  String getGoalName(goalindex) {
    String s = _goals[goalindex].name;
    return s;
  }

  List<Days> getCustomRepeat(int goalIndex) {
    return List.unmodifiable(_goals[goalIndex].customRepeat);
  }

  void restart() async {
    _goals = [];
    _totalPointsLeft = 1000;
    _totalAchievement = 0;
    permenantGoalId = 0;
    await DBHelper.deleteGoalsAndAchievement();
    notifyListeners();
  }
}
