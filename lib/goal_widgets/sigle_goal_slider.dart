import 'package:achivment_game/constants.dart';
import 'package:achivment_game/models/reward_class.dart';
import 'package:achivment_game/models/reward_list_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:achivment_game/models/golas_list_class.dart';

class SingleGoalSlider extends StatelessWidget {
  final int goalIndex;
  final Key key;
  SingleGoalSlider({@required this.goalIndex, this.key});

  @override
  Widget build(BuildContext context) {
    int boughtRewardsPoints() {
      int boughtRewardsPoints = 0;
      List<Reward> list =
          Provider.of<RewardList>(context, listen: false).boughtRewards;
      for (Reward reward in list) {
        boughtRewardsPoints += reward.points;
      }
      return boughtRewardsPoints;
    }

    bool checkValidation(int newValue) {
      int leftTotal = Provider.of<GoalsListClass>(context, listen: false)
              .getMaxPointLeft(goalIndex) -
          newValue.toInt();
      int newTotal = 1000 - leftTotal;
      if (newTotal > boughtRewardsPoints()) {
        return true;
      } else {
        return false;
      }
    }

    bool isChanged = false;
    return Card(
      margin: const EdgeInsets.all(10),
      key: key,
//                        margin: EdgeInsets.all(20.0),
      shape: k20RoundedRectangleBorder,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(
              'Points: ${Provider.of<GoalsListClass>(context).goals[goalIndex].points}',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            trailing: Text(
              'Points left:\n${Provider.of<GoalsListClass>(context).initialTotalPoints}',
              textAlign: TextAlign.center,
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.0,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 15.0,
              ),
            ),
            child: Slider(
              value: Provider.of<GoalsListClass>(context)
                  .goals[goalIndex]
                  .points
                  .toDouble(),
              min: 0.0,
              max: Provider.of<GoalsListClass>(context)
                  .getMaxPointLeft(goalIndex)
                  .toDouble(),
              onChanged: (newValue) {
                if (checkValidation(newValue.toInt())) {
                  // change the state of the value
                  Provider.of<GoalsListClass>(context, listen: false)
                      .getTotalPoints(newValue.toInt(), goalIndex, false);
                }
              },
              onChangeEnd: (newValue) {
                //change th database
                if (checkValidation(newValue.toInt())) {
                  // change the state of the value
                  Provider.of<GoalsListClass>(context, listen: false)
                      .getTotalPoints(newValue.toInt(), goalIndex, true);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
