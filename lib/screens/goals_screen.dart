import 'package:achivment_game/models/golas_list_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:achivment_game/screens/single_goal_screen.dart';
import 'package:achivment_game/goal_widgets/goals_list.dart';
import 'package:achivment_game/screens/add_goal_screen.dart';

class GoalsScreen extends StatelessWidget {
  static final String id = 'goals_screen';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    void _showSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled:
            true, // set this to true when using DraggableScrollableSheet as child
        builder: (_) {
          return AddGoalScreen();
        },
      );
    }

    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          FontAwesomeIcons.plus,
        ),
        onPressed: () {
          // show the AddAGoal sheet
          _showSheet();
        },
      ),
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: BackButton(
                onPressed: () {
                  // take the user back
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                bottom: 20,
                right: 40,
                left: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    child: const Icon(
                      FontAwesomeIcons.list,
                      color: Colors.blue,
                      size: 35,
                    ),
                    backgroundColor: Colors.white,
                    radius: 30,
                  ),
                  const Text(
                    'My Goals',
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                // check if there is no goals
                child: Provider.of<GoalsListClass>(context, listen: false)
                            .goals
                            .length !=
                        0
                    ? GoalsList(
                        // take the user to singleGoalScreen. depending on the goal index
                        // returned from the goalsList
                        onTap: (int index) async {
                          Provider.of<GoalsListClass>(context, listen: false)
                              .allStepNameBoolean(index);
                          await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SingleGoalScreen(
                              goalIndex: index,
                              onTapBox: () {},
                            );
                          }));
                        },
                      )
                    : Center(
                        child: const Text(
                          'Start adding your goals!',
                          style: const TextStyle(
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
