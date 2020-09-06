import 'package:achivment_game/constants.dart';
import 'package:achivment_game/models/StartingTimeStorage.dart';
import 'package:achivment_game/models/goal_class.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:achivment_game/screens/weekly_tracking_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:achivment_game/other_widgets//tracking_card.dart';
import 'package:achivment_game/other_widgets//circular_progress.dart';

class TrackingScreen extends StatelessWidget {
  static final String id = 'TrackingScreen';
  @override
  Widget build(BuildContext context) {
    List<Goal> listOfGoals = Provider.of<GoalsListClass>(context).goals;
    List<Widget> list = [];
    List<Widget> getTrackingCards() {
      for (int i = 0; i < listOfGoals.length; i++) {
        list.add(TrackingCard(
          goalIndex: i,
        ));
      }
      if (!list.contains(CircularProgress())) {
        list.add(CircularProgress());
      }
      return list;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              return WeeklyTrackingScreen();
            },
          );
        },
        child: Icon(FontAwesomeIcons.arrowUp),
        backgroundColor: kTrackingScreenColour,
      ),
      backgroundColor: kTrackingScreenColour,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: BackButton(
                onPressed: () {
                  // take the user back
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: 20,
                right: 40,
                left: 20,
              ),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        child: Icon(
                          FontAwesomeIcons.listAlt,
                          color: kTrackingScreenColour,
                          size: 39,
                        ),
                        backgroundColor: Colors.white,
                        radius: 30,
                      ),
                      Text(
                        'Tracking',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Provider.of<StartingTimeStorage>(context, listen: false)
                            .startingTime !=
                        null
                    ? ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: getTrackingCards(),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'You have to start the game!',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
