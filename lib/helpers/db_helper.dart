import 'package:achivment_game/models/reward_class.dart';
import 'package:achivment_game/models/step_class.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:achivment_game/models/goal_class.dart';

class DBHelper {
  static final String dbGOALS_TABLE = 'goals';
  static final String dbCOLUMN_GOLAS_ID = 'id';
  static final String dbCOLUMN_GOLAS_PERMANENT_ID = 'permanentId';
  static final String dbCOLUMN_GOLAS_NAME = 'name';
  static final String dbCOLUMN_GOLAS_ISDONE = 'isDone';
  static final String dbCOLUMN_GOLAS_POINTS = 'points';
  static final String dbCOLUMN_GOLAS_ACHIEVEMENT = 'achievement';
  static final String dbCOLUMN_GOLAS_REPEAT = 'repeat';
  static final String dbCOLUMN_GOLAS_REMINDER = 'reminder';
  static final String dbCOLUMN_GOLAS_CREATED_ON = 'createdOn';
  static final String dbCOLUMN_GOLAS_CUSTOM_TIME = 'customTime';
  static final String dbCOLUMN_GOLAS_CUSTOMREPEAT = 'customRepeat';
  static final String dbCOLUMN_GOALS_STEP_LIST = 'stepList';
  static final String dbGOALLIST_TABLE = 'goalList';
  static final String dbCOLUMN_GOALLIST_WEEK_NUM = 'WeekNum';
  static final String dbCOLUMN_GOALLIST_ACHIEVMENT_PERCENTAGE = 'achievment';
  static final String dbREWARDS_TABLE = 'rewards';
  static final String dbCOLUMN_REWARDS_ID = 'id';
  static final String dbCOLUMN_REWARDS_POINTS = 'points';
  static final String dbCOLUMN_REWARDS_TITLE = 'title';
  static final String dbCOLUMN_REWARDS_isBOUGHT = 'isBought';
  static final String dbCOLUMN_REWARDS_FILE_PATH = 'filePath';
  static final String dbOREDER_TABLE = 'orderTable';
  static final String dbCOLUMN_ORDER_ID = 'id';
  static final String dbCOLUMN_ORDER_GOALS_ORDER = 'goalsOrder';

  static Future<sql.Database> connectDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    print('path: $dbPath');
    return sql.openDatabase(
      path.join(dbPath, 'Achievement_Game.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE $dbGOALS_TABLE($dbCOLUMN_GOLAS_ID INTEGER PRIMARY KEY,$dbCOLUMN_GOLAS_PERMANENT_ID INTEGER, $dbCOLUMN_GOLAS_NAME TEXT,"
            "$dbCOLUMN_GOLAS_ISDONE INTEGER,$dbCOLUMN_GOLAS_POINTS INTEGER,$dbCOLUMN_GOLAS_ACHIEVEMENT TEXT,"
            "$dbCOLUMN_GOLAS_REPEAT INTEGER,$dbCOLUMN_GOLAS_REMINDER INTEGER,$dbCOLUMN_GOLAS_CREATED_ON TEXT,"
            "$dbCOLUMN_GOLAS_CUSTOM_TIME TEXT, $dbCOLUMN_GOLAS_CUSTOMREPEAT TEXT,"
            "$dbCOLUMN_GOALS_STEP_LIST TEXT)");
      },
      version: 1,
    );
  }

//Goal table's methods
  static Future<void> insertGoal(Goal goal) async {
    final sql.Database database = await connectDatabase();

    await database.insert(
        dbGOALS_TABLE,
        {
          dbCOLUMN_GOLAS_ID: goal.id,
          dbCOLUMN_GOLAS_PERMANENT_ID: goal.permanentId,
          dbCOLUMN_GOLAS_NAME: goal.name,
          dbCOLUMN_GOLAS_ISDONE: goal.isDone ? 0 : 1,
          dbCOLUMN_GOLAS_POINTS: goal.points,
          dbCOLUMN_GOLAS_ACHIEVEMENT: goal.achievement.toString(),
          dbCOLUMN_GOLAS_REPEAT: goal.repeat.index,
          dbCOLUMN_GOLAS_REMINDER: goal.reminder.index,
          dbCOLUMN_GOLAS_CREATED_ON: _createdOnToDatabase(goal.createdOn),
          dbCOLUMN_GOLAS_CUSTOM_TIME:
              _customDateTimeToDatabase(goal.customTime),
          dbCOLUMN_GOLAS_CUSTOMREPEAT:
              _customRepeatToDatabsae(goal.customRepeat),
          dbCOLUMN_GOALS_STEP_LIST: 'empty',
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static int _isDoneToDatabase(bool isDone) {
    int i = isDone ? 0 : 1;
    return i;
  }

  static String _createdOnToDatabase(DateTime dateTime) {
    return dateTime.toString().substring(0, 10);
  }

  static String _customDateTimeToDatabase(TimeOfDay timeOfDay) {
    if (timeOfDay != null) {
      return timeOfDay
          .toString()
          .substring(10, timeOfDay.toString().length - 1);
    } else {
      return 'empty';
    }
  }

  static String _customRepeatToDatabsae(List<Days> days) {
    if (days.length != 0) {
      //imprtant to initialize the string so it is not null
      String s = '';
      for (Days day in days) {
        s += '${day.index},';
      }
      // to delete the last comma , !!!
      return s.substring(0, s.length - 1);
    } else {
      return 'empty';
    }
  }

  static Future<List<Goal>> goals() async {
    final sql.Database database = await connectDatabase();
    await database.execute(
        '''CREATE TABLE IF NOT EXISTS $dbGOALS_TABLE($dbCOLUMN_GOLAS_ID INTEGER PRIMARY KEY
        ,$dbCOLUMN_GOLAS_PERMANENT_ID INTEGER, $dbCOLUMN_GOLAS_NAME TEXT
        ,$dbCOLUMN_GOLAS_ISDONE INTEGER, $dbCOLUMN_GOLAS_POINTS INTEGER
        ,$dbCOLUMN_GOLAS_ACHIEVEMENT TEXT, $dbCOLUMN_GOLAS_REPEAT INTEGER
        ,$dbCOLUMN_GOLAS_REMINDER INTEGER, $dbCOLUMN_GOLAS_CREATED_ON TEXT
        ,$dbCOLUMN_GOLAS_CUSTOM_TIME TEXT, $dbCOLUMN_GOLAS_CUSTOMREPEAT TEXT
        ,$dbCOLUMN_GOALS_STEP_LIST TEXT)''');
    final List<Map<String, dynamic>> maps = await database.query(dbGOALS_TABLE);
    List<Goal> goals = [];
    if (maps != null) {
      if (maps.length != 0) {
        goals = List.generate(maps.length, (index) {
          return Goal.dbHelper(
            //[indexOfTheMap][theKeyInTheMap]
            maps[index][dbCOLUMN_GOLAS_ID],
            maps[index][dbCOLUMN_GOLAS_PERMANENT_ID],
            maps[index][dbCOLUMN_GOLAS_NAME],
            _isDoneToGoal(maps[index][dbCOLUMN_GOLAS_ISDONE]),
            maps[index][dbCOLUMN_GOLAS_POINTS],
            double.parse(maps[index][dbCOLUMN_GOLAS_ACHIEVEMENT]),
            _repeatToGoal(maps[index][dbCOLUMN_GOLAS_REPEAT]),
            _reminderToGoal(maps[index][dbCOLUMN_GOLAS_REMINDER]),
            _createdOnToGoal(maps[index][dbCOLUMN_GOLAS_CREATED_ON]),
            _customTimeToGoal(maps[index][dbCOLUMN_GOLAS_CUSTOM_TIME]),
            _customRepeatToGoal(maps[index][dbCOLUMN_GOLAS_CUSTOMREPEAT]),
            _stepsToGoal(maps[index][dbCOLUMN_GOALS_STEP_LIST]),
          );
        });
      }
    }

    return goals;
  }

  static Future<void> checkGoal(Goal goal) async {
    sql.Database database = await connectDatabase();
    await database.rawUpdate(
        '''UPDATE $dbGOALS_TABLE SET $dbCOLUMN_GOLAS_ISDONE = ? 
    WHERE $dbCOLUMN_GOLAS_ID = ? ''',
        [_isDoneToDatabase(goal.isDone), goal.id]);
  }

  static Future<void> deleteGoal(int goalIndex) async {
    sql.Database database = await connectDatabase();
    // deleting goal
    await database.rawDelete(
        '''DELETE FROM $dbGOALS_TABLE WHERE $dbCOLUMN_GOLAS_ID= ?''',
        [goalIndex]);
    // refactor the id -1
    await database.rawUpdate(
        '''UPDATE $dbGOALS_TABLE SET $dbCOLUMN_GOLAS_ID= $dbCOLUMN_GOLAS_ID -1
    WHERE $dbCOLUMN_GOLAS_ID > ?''', [goalIndex]);
  }

  static Future<void> updateRepeat(Goal goal) async {
    sql.Database database = await connectDatabase();
    // deleting goal
    await database.rawUpdate(
      '''UPDATE $dbGOALS_TABLE SET $dbCOLUMN_GOLAS_REPEAT = ?
        , $dbCOLUMN_GOLAS_CUSTOMREPEAT = ? WHERE $dbCOLUMN_GOLAS_ID = ? ''',
      [goal.repeat.index, _customRepeatToDatabsae(goal.customRepeat), goal.id],
    );
  }

  static Future<void> updateReminder(Goal goal) async {
    sql.Database database = await connectDatabase();
    // deleting goal
    await database.rawUpdate(
      '''UPDATE $dbGOALS_TABLE SET $dbCOLUMN_GOLAS_REMINDER = ?
        , $dbCOLUMN_GOLAS_CUSTOM_TIME = ? WHERE $dbCOLUMN_GOLAS_ID = ? ''',
      [
        goal.reminder.index,
        _customDateTimeToDatabase(goal.customTime),
        goal.id
      ],
    );
  }

// some methods to interpret the data
  static bool _isDoneToGoal(int num) {
    if (num == 0) {
      return true;
    } else {
      return false;
    }
  }

  static Repeat _repeatToGoal(int num) {
    return Repeat.values[num];
  }

  static Reminder _reminderToGoal(int num) {
    return Reminder.values[num];
  }

  static DateTime _createdOnToGoal(String date) {
    if (date != null) {
      int year = int.parse(date.substring(0, 4));
      int month = int.parse(date.substring(5, 7));
      int day = int.parse(date.substring(8, 10));
      return DateTime(year, month, day);
    } else {
      return DateTime.now();
    }
  }

  static TimeOfDay _customTimeToGoal(String time) {
    if (time != 'empty') {
      int hour = int.parse(time.substring(0, time.length - 3));
      int minutes = int.parse(time.substring(time.length - 2, time.length));
      return TimeOfDay(hour: hour, minute: minutes);
    } else {
      return null;
    }
  }

  static List<Days> _customRepeatToGoal(String totalShit) {
    if (totalShit != 'empty') {
      List list = totalShit.split(',');
      List<Days> listOfDays = [];
      for (String s in list) {
        listOfDays.add(Days.values[int.parse(s)]);
      }
      return listOfDays;
    } else {
      List<Days> l = [];
      return l;
    }
  }

  static Future<void> insertStep(List<StepClass> steps, int goalIndex) async {
    sql.Database database = await connectDatabase();
    //reverse the number
    await database
        .rawUpdate('''UPDATE $dbGOALS_TABLE SET $dbCOLUMN_GOALS_STEP_LIST= ? 
      WHERE $dbCOLUMN_GOLAS_ID = ?''', [_stepToDatabase(steps), goalIndex]);
  }

  static String _stepToDatabase(List<StepClass> steps) {
    if (steps.length != 0) {
      String s = '';
      String done = '';
      for (int i = 0; i < steps.length; i++) {
        //.YES
        s += steps[i].name + '.ENOD';
        if (i != steps.length - 1) {
          done += steps[i].isDone ? '0' : '1';
          done += ',';
        } else {
          done += steps[i].isDone ? '0' : '1';
        }
      }
      //name.ENODname.ENOD1,0
      s += done;
      return s;
    } else {
      return 'empty';
    }
  }

  static List<StepClass> _stepsToGoal(String totalShit) {
    List<StepClass> steps = [];
    if (totalShit != 'empty') {
      //names then isDone
      //name.ENODname.ENOD1,0
      List nameList = totalShit.split('.ENOD');
      //string of the done list
      String done = nameList[nameList.length - 1];
      List doneList = done.split(',');
      bool isDone = false;
      //remember nameList includes 1 more element then doneList!!!!
      for (int i = 0; i < nameList.length - 1; i++) {
        if (doneList[i] == "1") {
          isDone = false;
        } else {
          isDone = true;
        }
        steps.add(StepClass.dbHelper(nameList[i], isDone));
      }
      return steps;
    } else {
      return steps;
    }
  }

  static Future<void> deleteGoalsAndAchievement() async {
    sql.Database database = await connectDatabase();
    await database.execute('DELETE FROM $dbGOALS_TABLE');
    await database.execute('DELETE FROM $dbGOALLIST_TABLE');
  }

  static Future<int> getGoalPoints(Goal goal) async {
    sql.Database database = await connectDatabase();
    List<Map<String, dynamic>> maps = await database
        .rawQuery('''SELECT $dbCOLUMN_GOLAS_POINTS FROM $dbGOALS_TABLE
         WHERE id= ?''', [goal.id]);
    int points = maps[0][dbCOLUMN_GOLAS_POINTS];
    return points;
  }

  static Future<void> _movingGoalForwards(
      Goal goal, int oldIndex, int newIndex) async {
    sql.Database database = await connectDatabase();
    //removing the goal
    await database.rawDelete(
        '''DELETE FROM $dbGOALS_TABLE WHERE $dbCOLUMN_GOLAS_ID = ?''',
        [oldIndex]);
    //updating the order of the goals in between
    await database.rawUpdate('''UPDATE $dbGOALS_TABLE SET 
    $dbCOLUMN_GOLAS_ID = $dbCOLUMN_GOLAS_ID -1 
    WHERE $dbCOLUMN_GOLAS_ID > ? AND $dbCOLUMN_GOLAS_ID <= ?''',
        [oldIndex, newIndex]);
    //adding the goal at the new index
    await database.insert(
      dbGOALS_TABLE,
      {
        dbCOLUMN_GOLAS_ID: newIndex,
        dbCOLUMN_GOLAS_PERMANENT_ID: goal.permanentId,
        dbCOLUMN_GOLAS_NAME: goal.name,
        dbCOLUMN_GOLAS_ISDONE: goal.isDone ? 0 : 1,
        dbCOLUMN_GOLAS_POINTS: goal.points,
        dbCOLUMN_GOLAS_ACHIEVEMENT: goal.achievement,
        dbCOLUMN_GOLAS_REPEAT: goal.repeat.index,
        dbCOLUMN_GOLAS_REMINDER: goal.reminder.index,
        dbCOLUMN_GOLAS_CREATED_ON: _createdOnToDatabase(goal.createdOn),
        dbCOLUMN_GOLAS_CUSTOM_TIME: _customDateTimeToDatabase(goal.customTime),
        dbCOLUMN_GOLAS_CUSTOMREPEAT: _customRepeatToDatabsae(goal.customRepeat),
        dbCOLUMN_GOALS_STEP_LIST: _stepToDatabase(goal.steps),
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> _movingGoalBackwords(
      Goal goal, int oldIndex, int newIndex) async {
    sql.Database database = await connectDatabase();
    //removing the goal
    //updating the order of the goals in between
    await database.rawUpdate('''UPDATE $dbGOALS_TABLE SET 
    $dbCOLUMN_GOLAS_ID = $dbCOLUMN_GOLAS_ID -1000 
    WHERE $dbCOLUMN_GOLAS_ID < ? AND $dbCOLUMN_GOLAS_ID >= ?''',
        [oldIndex, newIndex]);
    //updating the goal's id
    await database.rawUpdate('''UPDATE $dbGOALS_TABLE SET 
    $dbCOLUMN_GOLAS_ID = ?
    WHERE $dbCOLUMN_GOLAS_ID = ? ''', [newIndex, oldIndex]);
    //
    await database.rawUpdate('''UPDATE $dbGOALS_TABLE SET 
    $dbCOLUMN_GOLAS_ID = $dbCOLUMN_GOLAS_ID +1001 
    WHERE $dbCOLUMN_GOLAS_ID < ?''', [-1]);
  }

  static Future<void> updateGoalPosition(
      Goal goalAtTheOldIndex, int oldIndex, int newIndex) async {
    //if newIndex > oldIndex that means we are moving the goal forwards
    if (newIndex > oldIndex) {
      await _movingGoalForwards(goalAtTheOldIndex, oldIndex, newIndex);
    } else {
      await _movingGoalBackwords(goalAtTheOldIndex, oldIndex, newIndex);
    }
  }
//  updateGoalPoints

  static Future<void> updateGoalPoints(Goal goal) async {
    sql.Database database = await connectDatabase();
    await database
        .rawUpdate('''UPDATE $dbGOALS_TABLE SET $dbCOLUMN_GOLAS_POINTS = ? 
    WHERE $dbCOLUMN_GOLAS_ID = ? ''', [goal.points, goal.id]);
  }

  static Future<void> updateAchivement(Goal goal) async {
    sql.Database database = await connectDatabase();
    await database.rawUpdate(
        '''UPDATE $dbGOALS_TABLE SET $dbCOLUMN_GOLAS_ACHIEVEMENT
     = ? WHERE $dbCOLUMN_GOLAS_ID = ?''',
        [goal.achievement.toString(), goal.id]);
  }

  static Future<void> updateGoalName(Goal goal) async {
    sql.Database database = await connectDatabase();
    await database.rawUpdate('''UPDATE $dbGOALS_TABLE SET $dbCOLUMN_GOLAS_NAME
     = ? WHERE $dbCOLUMN_GOLAS_ID = ?''', [goal.name, goal.id]);
  }

//GoalList Table's methods

  static Future<void> creatGoalList(
      int weekNum, Map<int, double> map, int permenantGoalId) async {
    sql.Database database = await connectDatabase();
    await database.execute('''CREATE TABLE IF NOT EXISTS $dbGOALLIST_TABLE (
    $dbCOLUMN_GOALLIST_WEEK_NUM TEXT PRIMARY KEY, $dbCOLUMN_GOALLIST_ACHIEVMENT_PERCENTAGE TEXT)''');

    String s = _achievmentPercentaegeToDatabase(map, permenantGoalId);
    await database.insert(
      dbGOALLIST_TABLE,
      {
        dbCOLUMN_GOALLIST_WEEK_NUM: weekNum,
        dbCOLUMN_GOALLIST_ACHIEVMENT_PERCENTAGE: s,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateGoalListAchievementMap(
      Map<int, Map<int, double>> map) async {}

  static String _achievmentPercentaegeToDatabase(
      Map<int, double> map, int permenantGoalId) {
    String s = '';
    //the string will be like goalIndex.ENDpercentage
    //0,1,2.END0.2,0.54,0.9
    if (map != null) {
      for (int i = 0; i <= permenantGoalId; i++) {
        //making sure that the map holds info about this goalIndex
        if (map.containsKey(i)) {
          s += '$i,';
        }
      }
      print('s $s');
      s = s.substring(0, s.length - 1);
      s += '.END';
      for (int i = 0; i <= permenantGoalId; i++) {
        //making sure that the map holds info about this goalIndex
        if (map.containsKey(i)) {
          s += '${map[i]},';
        }
      }
      s = s.substring(0, s.length - 1);
      return s;
    } else {
      return '';
    }
  }

  static Future<Map<int, Map<int, double>>> achievmentData() async {
    sql.Database database = await connectDatabase();
    await database.execute('''CREATE TABLE IF NOT EXISTS $dbGOALLIST_TABLE (
    $dbCOLUMN_GOALLIST_WEEK_NUM TEXT PRIMARY KEY, $dbCOLUMN_GOALLIST_ACHIEVMENT_PERCENTAGE TEXT)''');

    List<Map<String, dynamic>> listOfMaps =
        await database.query(dbGOALLIST_TABLE);

    Map<int, Map<int, double>> maps = {};
    if (listOfMaps != null) {
      if (listOfMaps.length != 0) {
        for (int i = 0; i < listOfMaps.length; i++) {
          int weekNum = int.parse(listOfMaps[i][dbCOLUMN_GOALLIST_WEEK_NUM]);
          //initialize the map
          maps[weekNum] = {};
          //the map will then have the weekNum as key
          maps[weekNum] = _achievmentDataToGoalList(
              listOfMaps[0][dbCOLUMN_GOALLIST_ACHIEVMENT_PERCENTAGE]);
        }
      }
    }
    return maps;
  }

  static Map<int, double> _achievmentDataToGoalList(String data) {
    Map<int, double> map = {};
    if (data != null) {
      if (data.length != 0) {
        List list = data.split('.END');
        String g = list[0];
        List goalIndex = g.split(',');
        String v = list[1];
        List values = v.split(',');
        for (int i = 0; i < values.length; i++) {
          map[int.parse(goalIndex[i])] = double.parse(values[i]);
        }
      }
    }
    return map;
  }

//Reward table's methods
  static Future<void> addReward(Reward reward) async {
    sql.Database database = await connectDatabase();
    await database.execute('''CREATE TABLE IF NOT EXISTS $dbREWARDS_TABLE (
    $dbCOLUMN_REWARDS_ID INTEGER PRIMARY KEY, $dbCOLUMN_REWARDS_POINTS INTEGER, 
    $dbCOLUMN_REWARDS_TITLE TEXT, $dbCOLUMN_REWARDS_isBOUGHT INTEGER, 
    $dbCOLUMN_REWARDS_FILE_PATH TEXT )''');

    await database.insert(
      dbREWARDS_TABLE,
      {
        dbCOLUMN_REWARDS_ID: reward.id,
        dbCOLUMN_REWARDS_POINTS: reward.points,
        dbCOLUMN_REWARDS_TITLE: reward.title,
        dbCOLUMN_REWARDS_isBOUGHT: _rewardIsBoughtToDatabase(reward.isBought),
        dbCOLUMN_REWARDS_FILE_PATH: reward.filePath,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static int _rewardIsBoughtToDatabase(bool isBought) {
    if (isBought) {
      return 0;
    } else {
      return 1;
    }
  }

  static Future<List<Reward>> rewards() async {
    sql.Database database = await connectDatabase();
    await database.execute('''CREATE TABLE IF NOT EXISTS $dbREWARDS_TABLE (
    $dbCOLUMN_REWARDS_ID INTEGER PRIMARY KEY, $dbCOLUMN_REWARDS_POINTS INTEGER, 
    $dbCOLUMN_REWARDS_TITLE TEXT, $dbCOLUMN_REWARDS_isBOUGHT INTEGER, 
    $dbCOLUMN_REWARDS_FILE_PATH TEXT )''');

    List<Map<String, dynamic>> listOfMaps =
        await database.query(dbREWARDS_TABLE);
    List<Reward> list = [];
    if (listOfMaps != null) {
      if (listOfMaps.length != 0) {
        list = List.generate(listOfMaps.length, (index) {
          return Reward.dbHelper(
            listOfMaps[index][dbCOLUMN_REWARDS_ID],
            listOfMaps[index][dbCOLUMN_REWARDS_POINTS],
            listOfMaps[index][dbCOLUMN_REWARDS_TITLE],
            _rewardIsBoughtToRewards(
                listOfMaps[index][dbCOLUMN_REWARDS_isBOUGHT]),
            listOfMaps[index][dbCOLUMN_REWARDS_FILE_PATH],
          );
        });
      }
    }
    return list;
  }

  static bool _rewardIsBoughtToRewards(int num) {
    if (num == 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> updateRewardIsBought(Reward reward) async {
    sql.Database database = await connectDatabase();
    await database.rawUpdate(
        '''UPDATE $dbREWARDS_TABLE SET $dbCOLUMN_REWARDS_isBOUGHT = ? 
    WHERE $dbCOLUMN_REWARDS_ID = ? ''',
        [_rewardIsBoughtToDatabase(reward.isBought), reward.id]);
  }

  static Future<void> deleteReward(int rewardId) async {
    sql.Database database = await connectDatabase();
    await database
        .rawDelete('''DELETE FROM $dbREWARDS_TABLE WHERE id= ?''', [rewardId]);
    // refactor the id -1
    await database.rawUpdate(
        '''UPDATE $dbREWARDS_TABLE SET $dbCOLUMN_REWARDS_ID= $dbCOLUMN_REWARDS_ID -1 
    WHERE $dbCOLUMN_REWARDS_ID > ?''', [rewardId]);
  }

  static Future<void> deleteAllRewards() async {
    sql.Database database = await connectDatabase();
    await database.execute('DELETE FROM $dbREWARDS_TABLE');
  }
}
