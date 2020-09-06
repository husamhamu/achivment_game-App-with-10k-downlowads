import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StartingTimeStorage extends ChangeNotifier {
  DateTime _startingTime;
  int _numberOfTheWeeks = 0;

  Future<String> get _localPath async {
    //finding path to the documents directory on the app
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    // getting the path
    final path = await _localPath;
    //return the file object
    return File('$path/startingTime.txt');
  }

  Future<File> writeStartingTime(DateTime dateTime, int weekNum) async {
    //getting the file
    final file = await _localFile;
    //write the file
    file.writeAsString(
        '${dateTime.year},${dateTime.month},${dateTime.day},$weekNum');
    notifyListeners();
    return file;
  }

  Future<DateTime> readStartingTime() async {
    try {
      //getting the file
      final file = await _localFile;
      String contents = await file.readAsString();
      if (contents.length != 4) {
        List<String> list = contents.split(',');
        DateTime dateTime = DateTime(
            int.parse(list[0]), int.parse(list[1]), int.parse(list[2]));
        _numberOfTheWeeks = int.parse(list[3]);
        _startingTime = dateTime;
        return dateTime;
      } else {
        _startingTime = null;
        _numberOfTheWeeks = 0;
        return null;
      }
    } catch (e) {
      _startingTime = null;
      _numberOfTheWeeks = 0;
      return null;
    } finally {
      notifyListeners();
      print('_startingTime $_startingTime');
    }
  }

  int numberOfTheWeek() {
    if (_numberOfTheWeeks > 0) {
      return _numberOfTheWeeks;
    } else {
      return 1;
    }
  }

  int numberOftheCurrentWeek() {
    DateTime dateTime = DateTime.now();
//    DateTime dateTime = DateTime(2020, 9, 27);
    if (_startingTime != null) {
      Duration duration = dateTime.difference(_startingTime);
      double percentage = (duration.inDays + 1) / 7;
      double weekNum = 1;
      for (int i = 0; i < numberOfTheWeeks; i++) {
        if (percentage <= weekNum) {
          return weekNum.toInt();
        } else {
          weekNum++;
        }
      }
    }

    return numberOfTheWeeks;
  }

  int numberOfTheCurrentDay() {
    DateTime dateTime = DateTime.now();
//    DateTime dateTime = DateTime(2020, 9, 27);
    int maxDaysNum = numberOfTheWeeks * 7;

    if (_startingTime != null) {
      Duration duration = dateTime.difference(_startingTime);
      if (duration.inDays + 1 <= maxDaysNum) {
        return (duration.inDays + 1);
      } else {
        return maxDaysNum;
      }
    } else {
      return -1;
    }
  }

  void restart() async {
    final file = await _localFile;
    file.writeAsString('null');
    _startingTime = null;
    _numberOfTheWeeks = 0;
    notifyListeners();
  }

  DateTime get startingTime => _startingTime;

  int get numberOfTheWeeks => _numberOfTheWeeks;
}
