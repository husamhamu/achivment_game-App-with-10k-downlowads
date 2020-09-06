import 'package:achivment_game/helpers/db_helper.dart';
import 'package:achivment_game/models/StartingTimeStorage.dart';
import 'package:achivment_game/models/goal_class.dart';
import 'package:achivment_game/models/notification_plugin.dart';
import 'package:achivment_game/models/reward_class.dart';
import 'package:achivment_game/models/reward_list_class.dart';
import 'package:achivment_game/screens/TrackingScreen.dart';
import 'package:achivment_game/screens/about_screen.dart';
import 'package:achivment_game/screens/custom_3DDrawer.dart';
import 'package:achivment_game/screens/home_screen.dart';
import 'package:achivment_game/screens/rewards_screen.dart';
import 'package:achivment_game/screens/weekly_tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:achivment_game/screens/goals_screen.dart';
import 'package:provider/provider.dart';
import 'package:achivment_game/models/golas_list_class.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    //this the goals list to keep the UI up to to date using provider power
    GoalsListClass goalsList = GoalsListClass();

    //this is used  to store the starting time data
    StartingTimeStorage startingTimeStorage = StartingTimeStorage();

    List<Days> listofDays = [];
    //this goal is used in the addGoalScreen to keep the data when the user decides to add them
    //using provider
    Goal goal = Goal(1000, 1000, 'temp', Repeat.nothingChosen,
        Reminder.nothingChosen, listofDays, null);
    goal.customRepeat = [];

    //reward list to update the UI
    RewardList rewardList = RewardList();

    void waitForDataToLoad() async {
      //we push the settings screen after we get the data
      await startingTimeStorage.readStartingTime();
    }

    waitForDataToLoad();

    void gettingGoals() async {
      List<Goal> goals = await DBHelper.goals();
      final maps = await DBHelper.achievmentData();
      goalsList.retrievingData(goals, maps);
    }

    gettingGoals();

    void gettingRewards() async {
      List<Reward> rewards = await DBHelper.rewards();
      rewardList.retrievingData(rewards);
    }

    gettingRewards();

    //initialize the notifications plugin
    onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}
    onNotificationClick(String payload) {}

    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RewardList>(
          create: (_) => rewardList,
        ),
        ChangeNotifierProvider<StartingTimeStorage>(
          create: (_) => startingTimeStorage,
        ),
        ChangeNotifierProvider<GoalsListClass>(
          create: (_) => goalsList,
        ),
        ChangeNotifierProvider<Goal>(
          create: (_) => goal,
        ),
      ],
      child: MaterialApp(
//          theme: ThemeData.dark(),
        home: Custom3DDrawer(),
        routes: {
          GoalsScreen.id: (context) => GoalsScreen(),
          HomeScreen.id: (context) => GoalsScreen(),
          TrackingScreen.id: (context) => TrackingScreen(),
          WeeklyTrackingScreen.id: (context) => WeeklyTrackingScreen(),
          RewardsScreen.id: (context) => RewardsScreen(),
          Custom3DDrawer.id: (context) => Custom3DDrawer(),
          AboutScreen.id: (context) => AboutScreen(),
        },
      ),
    );
  }
}

// //SplashScreen
// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     void waitForDataToLoad() async {
//       //we push the settings screen after we get the data
//       await Provider.of<StartingTimeStorage>(context, listen: false)
//           .readStartingTime()
//           .then((value) {
//         print('hii');
//         //we pop the splash screen so that the user does not navigate to it again
//         Navigator.popAndPushNamed(context, Custom3DDrawer.id);
//       });
//     }
//
//     waitForDataToLoad();
//
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       body: Center(
//         child: Image.asset(
//           'images/logo.jpg',
//         ),
//       ),
//     );
//   }
// }
