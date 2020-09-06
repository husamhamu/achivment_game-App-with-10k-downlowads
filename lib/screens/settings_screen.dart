import 'package:achivment_game/constants.dart';
import 'package:achivment_game/models/StartingTimeStorage.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:achivment_game/models/notifications_manager.dart';
import 'package:achivment_game/models/reward_list_class.dart';
import 'package:achivment_game/screens/about_screen.dart';
import 'package:achivment_game/screens/custom_3DDrawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    Future<void> showingRestartDialog() async {
      await showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('You will lose all the data if you restart.'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.black),
              ),
            ),
            FlatButton(
              onPressed: () async {
                //restart
                Provider.of<GoalsListClass>(context, listen: false).restart();
                Provider.of<RewardList>(context, listen: false).restart();
                Provider.of<StartingTimeStorage>(context, listen: false)
                    .restart();
                await NotificationsManager.cancelAllNotification();

                Navigator.of(context).pop();
                Future.delayed(Duration(milliseconds: 450)).then((value) {
                  Custom3DDrawer.of(context).toggle();
                });
                Future.delayed(Duration(milliseconds: 900)).then((value) {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                            const Text('Game is restarted')
                          ],
                        ),
                      ));
                });
              },
              child: const Text(
                'RESTART',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: screenWidth * 0.729,
      height: double.infinity,
      child: Material(
        color: Colors.blue,
        child: SafeArea(
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenWidth * 0.03,
                        left: screenWidth * 0.1,
                        bottom: screenWidth * 0.03),
                    child: Image.asset('images/appIcon.jpg',
                        width: screenWidth * 0.5),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, AboutScreen.id)
                          .then((value) {
                        Custom3DDrawer.of(context).toggle();
                      });
                    },
                    leading: const Icon(
                      FontAwesomeIcons.mobileAlt,
                      size: 30,
                    ),
                    title: const Text(
                      'About',
                      style: kTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Custom3DDrawer.of(context).toggle();
                      Share.share('check out my website https://example.com');
                    },
                    leading: const Icon(
                      FontAwesomeIcons.shareAltSquare,
                      size: 30,
                    ),
                    title: const Text(
                      'Share the app',
                      style: kTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: showingRestartDialog,
                    leading: const Icon(
                      Icons.refresh,
                      size: 30,
                    ),
                    title: const Text(
                      'Restart the game',
                      style: kTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
