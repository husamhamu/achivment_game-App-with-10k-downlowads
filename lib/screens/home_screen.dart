import 'package:achivment_game/constants.dart';
import 'package:achivment_game/models/StartingTimeStorage.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:achivment_game/models/notification_plugin.dart';

import 'package:achivment_game/models/reward_list_class.dart';
import 'package:achivment_game/other_widgets/start_alert_dialog.dart';
import 'package:achivment_game/screens/TrackingScreen.dart';
import 'package:achivment_game/screens/goals_screen.dart';
import 'package:achivment_game/screens/rewards_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:achivment_game/other_widgets/home_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static final String id = 'home_scereen';
  final AppBar appBar;

  HomeScreen({Key key, @required this.appBar});

  @override
  Widget build(BuildContext context) {
    void showStartedSnack() async {
      Future.delayed(Duration(milliseconds: 700)).then((value) async {
        await showDialog(
          context: context,
          child: AlertDialog(
            content: Row(
              children: <Widget>[
                const Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 25,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Congratulations!\n',
                        style:
                            const TextStyle(color: Colors.green, fontSize: 18),
                      ),
                      const TextSpan(
                        text: 'Game has started!',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }

    Future<void> shwoStartDataDialog() async {
      await showDialog(
        context: context,
        child: StartAlertDialog(
          gameStarted: showStartedSnack,
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Widget animatedSwitcherChild;
    if (Provider.of<StartingTimeStorage>(context).startingTime == null) {
      animatedSwitcherChild = Padding(
        padding: const EdgeInsets.only(top: 5),
        child: MaterialButton(
          elevation: 15,
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08, vertical: 10),
          color: Colors.blue,
          shape: k20RoundedRectangleBorder,
          onPressed: () async {
            //
            await shwoStartDataDialog();
          },
          child: const Text(
            'Start!',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    } else {
      animatedSwitcherChild = Container();
    }
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: appBar,
      body: Column(
        children: [
          Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.1,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: FittedBox(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return RadialGradient(
                    center: Alignment.topCenter,
                    radius: screenWidth * 0.025,
                    colors: [
                      Colors.lightBlueAccent,
                      Colors.white,
                    ],
                  ).createShader(bounds);
                },
                child: const Text(
                  'It feels good to get some stuff done!',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Grandstander',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              height: screenHeight * 0.5,
              child: ListView(
                children: <Widget>[
//          HomeCard(
//            icon: Icon(
//              Icons.wb_sunny,
//              color: Colors.yellow,
//            ),
//            text: 'My Day',
//            onTap: () {
//              // take the user to MyDayScreen
//
//              Navigator.pushNamed(context, DemoScreen.id);
//            },
//            itemsNumber: 5,
//          ),
                  HomeCard(
                    icon: const Icon(
                      FontAwesomeIcons.list,
                      color: Colors.lightBlueAccent,
                    ),
                    text: 'Goals',
                    onTap: () async {
                      Navigator.pushNamed(context, GoalsScreen.id);
                    },
                    itemsNumber:
                        Provider.of<GoalsListClass>(context).goals.length,
                  ),
                  HomeCard(
                    icon: const Icon(
                      FontAwesomeIcons.listAlt,
                      color: Colors.lightBlueAccent,
                    ),
                    text: 'Tracking',
                    onTap: () {
                      // take the user to my day screen
                      Navigator.pushNamed(context, TrackingScreen.id);
                    },
                    itemsNumber:
                        Provider.of<GoalsListClass>(context).goals.length,
                  ),
                  HomeCard(
                    icon: const Icon(
                      FontAwesomeIcons.gift,
                      color: Colors.lightBlueAccent,
                    ),
                    text: 'Rewards',
                    onTap: () {
                      Navigator.pushNamed(context, RewardsScreen.id);
                    },
                    itemsNumber:
                        Provider.of<RewardList>(context).rewards.length,
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        child: child,
                        scale: animation,
                      );
                    },
                    child: animatedSwitcherChild,
                  ),
                  // FlatButton(
                  //   color: Colors.blue,
                  //   onPressed: () async {
                  //     // await notificationPlugin.showNotification();
                  //     // await notificationPlugin.showDailyAtTime();
                  //     // await notificationPlugin.cancelAllNotification();
                  //     int count = await notificationPlugin
                  //         .getPendingNotificationCount();
                  //     print('count $count');
                  //   },
                  //   child: Text('show notification'),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Visibility(
//   visible:
//       Provider.of<StartingTimeStorage>(context).startingTime == null
//           ? true
//           : false,
//   child: Padding(
//     padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.3),
//     child: MaterialButton(
//       elevation: 15,
//       color: Colors.blue,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(15)),
//       ),
//       onPressed: () async {
//         //
//         await shwoStartDataDialog();
//       },
//       child: Text(
//         'Start!',
//         style: TextStyle(color: Colors.white, fontSize: 18),
//       ),
//     ),
//   ),
// ),
