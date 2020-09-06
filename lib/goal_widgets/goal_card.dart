import 'package:achivment_game/constants.dart';
import 'package:achivment_game/models/goal_class.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:flutter/material.dart';
import 'package:achivment_game/goal_widgets//rounded_check_box.dart';
import 'package:provider/provider.dart';

class GoalCard extends StatelessWidget {
  final String name;
  final Function onTapBox;
  final bool isDone;
  final Function onTap;
  final Key key;
  final bool showData;
  final int stepsNum;
  final Repeat repeat;
  final int goalIndex;

  GoalCard({
    @required this.name,
    @required this.onTapBox,
    @required this.isDone,
    this.onTap,
    this.key,
    @required this.showData,
    this.stepsNum,
    this.repeat,
    @required this.goalIndex,
  });
  @override
  Widget build(BuildContext context) {
    String repeatData() {
      String repeatMeaning;
      if (repeat == Repeat.daily) {
        repeatMeaning = 'daily';
      } else if (repeat == Repeat.weekly) {
        repeatMeaning = 'weekly';
      } else {
        repeatMeaning = null;
      }
      return repeatMeaning;
    }

    return Card(
      key: key,
      shape: k20RoundedRectangleBorder,
      elevation: 10,
      child: ListTile(
        shape: k20RoundedRectangleBorder,
        // take the user to the SingleGoalScreen // or click on agoal to update the name
        onTap: onTap,
        title: Text(
          name,
          style: TextStyle(
            fontSize: 20,
            decoration:
                isDone ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),

        // rounded checkbox
        trailing: RoundedCheckBox(
          onTap: onTapBox,
          isDone: isDone,
        ),
        subtitle: (showData & ((stepsNum != 0) | (repeatData() != null)))
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: <Widget>[
                    if (stepsNum != 0) Text('$stepsNum Steps'),
                    if (stepsNum != 0) Spacer(flex: 1),
                    if (stepsNum != 0)
                      Text(
                          '${Provider.of<GoalsListClass>(context).numberOfTheDoneSteps(goalIndex)} done'),
                    if (stepsNum != 0) Spacer(flex: 1),
                    if (repeatData() != null)
                      Icon(
                        Icons.repeat,
                        size: 15,
                      ),
                    if (repeatData() != null) SizedBox(width: 5),
                    if (repeatData() != null) Text(repeatData()),
                    Spacer(flex: 10),
//            Text('secret goal'),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
