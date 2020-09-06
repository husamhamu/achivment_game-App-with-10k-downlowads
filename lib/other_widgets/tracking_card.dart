import 'package:achivment_game/models/StartingTimeStorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:achivment_game/constants.dart';

class TrackingCard extends StatelessWidget {
  final int goalIndex;

  TrackingCard({this.goalIndex});

  @override
  Widget build(BuildContext context) {
//remember not using this in areas where the UI got build for the first time!!!
    final goalListProvider =
        Provider.of<GoalsListClass>(context, listen: false);

    int percent() {
      bool shown = false;
      double percent = 0.0;
      if (goalListProvider.getGoalPoints(goalIndex) != 0) {
        percent = (goalListProvider.achievedPointsForGoal(goalIndex) /
                goalListProvider.getGoalPoints(goalIndex)) *
            100;
      }
      return percent.toInt();
    }

    Widget animatedSwitcherChild = percent() == 100
        ? Container(
            child: const Icon(
              Icons.star,
              size: 45,
              color: Color(0xFF4AA079),
            ),
          )
        : const Icon(
            Icons.star_border,
            size: 45,
            color: Color(0xFF4AA079),
          );
    return Card(
      elevation: 10,
      shape: k20RoundedRectangleBorder,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  child: child,
                  scale: animation,
                );
              },
              child: animatedSwitcherChild,
            ),
            title: Text(
              goalListProvider.getGoalName(goalIndex),
              style: TextStyle(fontSize: 20),
            ),
            trailing: Text(
              'Achieved\n points:\n${Provider.of<GoalsListClass>(context).achievedPointsForGoal(goalIndex)}',
              textAlign: TextAlign.center,
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 25.0,
              thumbShape: SliderComponentShape.noThumb,
            ),
            child: Slider(
              value: Provider.of<GoalsListClass>(context)
                  .achievedPointsForGoal(goalIndex)
                  .toDouble(),
              onChanged: (newValue) {
                //we font want to update the db now until the end
                int numberOftheCurrentWeek =
                    Provider.of<StartingTimeStorage>(context, listen: false)
                        .numberOftheCurrentWeek();
                Provider.of<GoalsListClass>(context, listen: false)
                    .updateAchievement(goalIndex, numberOftheCurrentWeek,
                        newValue.toInt(), false);
              },
              onChangeEnd: (newValue) {
                //getting the number of the currentWeek
                int numberOftheCurrentWeek =
                    Provider.of<StartingTimeStorage>(context, listen: false)
                        .numberOftheCurrentWeek();
                //finally updating the database
                Provider.of<GoalsListClass>(context, listen: false)
                    .updateAchievement(goalIndex, numberOftheCurrentWeek,
                        newValue.toInt(), true);
              },
              min: 0.0,
              max: Provider.of<GoalsListClass>(context)
                  .getGoalPoints(goalIndex)
                  .roundToDouble(),
              divisions: Provider.of<GoalsListClass>(context)
                          .getGoalPoints(goalIndex) ==
                      0
                  ? 10
                  : Provider.of<GoalsListClass>(context)
                      .getGoalPoints(goalIndex),
              label: "${percent()}%",
              activeColor: kTrackingScreenColour,
            ),
          ),
        ],
      ),
    );
  }
}
