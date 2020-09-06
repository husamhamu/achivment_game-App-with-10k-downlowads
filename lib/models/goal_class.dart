import 'package:achivment_game/helpers/db_helper.dart';
import 'package:achivment_game/models/step_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum Reminder {
  Morning,
  Afternoon,
  Night,
  // we will show a TimePicker for this one:
  pickTime,
  nothingChosen,
}

enum Repeat {
  daily,
  weekly,
  nothingChosen,
}
// [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday];
enum Days {
  Sunday,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  nothingChosen,
}

class Goal with ChangeNotifier {
  int _id;
  bool _isDone = false;
  String _name = '';
  int _points = 0;
  List<StepClass> _steps;
  DateTime _createdOn = DateTime.now();
  Repeat _repeat;
  List<Days> _weekly;
  Reminder _reminder;
  TimeOfDay _customTime;
  double _achievement = 0.0;
  int _permanentId;

  Goal(this._id, this._permanentId, this._name, this._repeat, this._reminder,
      this._weekly, this._customTime) {
    this._steps = [];
  }

  Goal.dbHelper(
      this._id,
      this._permanentId,
      this._name,
      this._isDone,
      this._points,
      this._achievement,
      this._repeat,
      this._reminder,
      this._createdOn,
      this._customTime,
      this._weekly,
      this._steps);

  int get permanentId => _permanentId;

  set permanentId(int value) {
    _permanentId = value;
    notifyListeners();
  } //  Goal.repeat(this._name, this._repeat) {
//    this._steps = [];
//  }
//  Goal.customRepeat(this._name, this._customRepeat) {
//    _repeat = Repeat.custom;
//    this._steps = [];
//  }
//  Goal.dateTime(this._name, this._reminder) {
//    this._steps = [];
//  }
//  Goal.customDateTime(this._name, this._customDateTime) {
//    this._reminder = Reminder.pickTime;
//    this._steps = [];
//  }
//  Goal.customDateTimeAndCustomtrepeat(
//      this._name, this._customDateTime, this._customRepeat) {
//    _repeat = Repeat.custom;
//    _reminder = Reminder.pickTime;
//    this._steps = [];
//  }
//  Goal.dateTimeAndRepeat(this._name, this._reminder, this._repeat) {
//    this._steps = [];
//  }

  void checkGoal() {
    this._isDone = !_isDone;
    notifyListeners();
  }

  void addStep(String name) async {
    if (name != null && name.isNotEmpty) {
      _steps.add(StepClass(name));
    }
    notifyListeners();
  }

  void checkStep(int index) {
    print('$index < ${_steps.length}');
    if (index < _steps.length) {
      print('hi');
      _steps[index].checkStep();
    }
    notifyListeners();
  }

  void setPoints(int num) {
    print('setPoints $num');
    this._points = num;
    notifyListeners();
  }

  List<StepClass> get steps => List.unmodifiable(_steps);
  void updateStepNameBoolean(int stepIndex, bool value) {
    _steps[stepIndex].updateName = !_steps[stepIndex].updateName;
    for (int i = 0; i < _steps.length; i++) {
      if (i != stepIndex) {
        _steps[i].updateName = false;
      }
    }
  }

  void updateStepName(int stepIndex, String newName) {
    _steps[stepIndex].name = newName;
  }

  void updateAllStepNameBoolean(bool value) {
    for (StepClass stepClass in _steps) {
      stepClass.updateName = value;
    }
    notifyListeners();
  }

  void updateStepPositino(int oldIndex, int newIndex) {
    StepClass step = _steps[oldIndex];
    _steps.removeAt(oldIndex);
    _steps.insert(newIndex, step);
    notifyListeners();
  }

  void deleteStep(int stepIndex) {
    if (stepIndex < steps.length) {
      _steps.removeAt(stepIndex);
    }
  }

  String get name => _name;

  int get points => _points;

  bool get isDone => _isDone;

  List<Days> get customRepeat => List.unmodifiable(_weekly);

  Repeat get repeat => _repeat;

  DateTime get createdOn => _createdOn;

  Reminder get reminder => _reminder;

  TimeOfDay get customTime => _customTime;

  set reminder(Reminder value) {
    _reminder = value;
    notifyListeners();
  }

  set customRepeat(List<Days> value) {
    _weekly = value;
    notifyListeners();
  }

  set repeat(Repeat value) {
    _repeat = value;
    notifyListeners();
  }

  set createdOn(DateTime value) {
    _createdOn = value;
    notifyListeners();
  }

  set customTime(TimeOfDay value) {
    _customTime = value;
    notifyListeners();
  }

  set steps(List<StepClass> value) {
    _steps = value;
    notifyListeners();
  }

  set points(int value) {
    _points = value;
    notifyListeners();
  }

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set isDone(bool value) {
    _isDone = value;
    notifyListeners();
  }

  double get achievement => _achievement;

  set achievement(double value) {
    _achievement = value;
    notifyListeners();
  }

  int get id => _id;

  set id(int value) {
    _id = value;
    notifyListeners();
  }
}
