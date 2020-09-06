import 'package:achivment_game/constants.dart';
import 'package:achivment_game/goal_widgets/rounded_check_box.dart';
import 'package:achivment_game/goal_widgets/single_goal_reminder_card.dart';
import 'package:achivment_game/goal_widgets/single_goal_repeat.dart';
import 'package:achivment_game/models/StartingTimeStorage.dart';
import 'package:achivment_game/models/goal_class.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:achivment_game/goal_widgets/sigle_goal_slider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:achivment_game/models/step_class.dart';
import 'package:achivment_game/goal_widgets/step_card.dart';

class SingleGoalScreen extends StatelessWidget {
  static final String id = 'singleGoalScreen';
  final Function onTapBox;
  int goalIndex;

  SingleGoalScreen({@required this.onTapBox, @required this.goalIndex});

  final textEditingController = TextEditingController();
  final goalTextEditingController = TextEditingController();
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    bool keyboardOff =
        MediaQuery.of(context).viewInsets.bottom != 0 ? true : false;

    if (keyboardOff) {}

    // using the power of provider *_*
    Goal goal = Provider.of<GoalsListClass>(context).goals[goalIndex];
    // step list
    List<StepClass> goalsSteps = goal.steps;
    List<Widget> stepCards = [];
    List<Widget> getSteps() {
      int index = 0;
      for (int stepIndex = 0; stepIndex < goalsSteps.length; stepIndex++) {
        stepCards.add(
          StepCard(
            key: ValueKey('${goal.steps[index].name} $index'),
            stepIndex: stepIndex,
            goalIndex: goalIndex,
            name: goal.steps[index].name,
            isDone: goal.steps[index].isDone,
            onTap: () {
              print(stepIndex);
            },
          ),
        );
        index++;
      }
      return stepCards;
    }

    void addStep() {
      // add step
      //close the keyboard
      FocusScope.of(context).requestFocus(new FocusNode());
      Provider.of<GoalsListClass>(context, listen: false)
          .addStep(goalIndex, textEditingController.text);
      textEditingController.clear();
    }

    void showAlertDialog() async {
      await showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Are you sure?'),
          content: Text('"${goal.name}" will be permanently deleted.'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CANCEL',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            FlatButton(
              child: const Text(
                'DELETE',
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                //getting the number of the currentWeek

                int numberOftheCurrentWeek =
                    Provider.of<StartingTimeStorage>(context, listen: false)
                        .numberOftheCurrentWeek();

                Provider.of<GoalsListClass>(context, listen: false)
                    .deleteGoal(goalIndex, numberOftheCurrentWeek);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: ListTile(
        title: Text(
          'created on ${goal.createdOn.toString().substring(0, 10)}',
          style: const TextStyle(color: Colors.black38),
        ),
        trailing: FittedBox(
          child: IconButton(
            icon: const Icon(
              Icons.delete,
              size: 30.0,
            ),
            onPressed: () {
              //delete the goal
              showAlertDialog();
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: BackButton(
                onPressed: () {
//                Provider.of<GoalsListClass>(context, listen: false)
//                    .updatingAcgievmentGoalBcauseOfChangeInThePoints(goalIndex);
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
              child: Card(
                shape: k20RoundedRectangleBorder,
                elevation: 10,
                child: ListTile(
                  shape: k20RoundedRectangleBorder,
                  // or click on a goal to update the name
                  onTap: () {
                    Provider.of<GoalsListClass>(context, listen: false)
                        .updateNameBoolean();
                    goalTextEditingController.text = goal.name;
                  },
                  // updating the goal name
                  title: Provider.of<GoalsListClass>(context).updateName
                      ? TextField(
                          controller: goalTextEditingController,
                          decoration: InputDecoration(),
                          autofocus: true,
                          maxLines: 2,
                          minLines: 1,
                          keyboardType: TextInputType.text,
                          onSubmitted: (_) {
                            //update the goalName
                            Provider.of<GoalsListClass>(context, listen: false)
                                .updateGoalName(
                                    goalIndex, goalTextEditingController.text);
                            //change the widget to be a text agian
                            Provider.of<GoalsListClass>(context, listen: false)
                                .updateNameBoolean();
                          },
                        )
                      : Text(
                          goal.name,
                          style: TextStyle(
                            fontSize: 20,
                            decoration: goal.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                  // rounded checkbox
                  trailing: RoundedCheckBox(
                    onTap: () {
                      // check the goal
                      Provider.of<GoalsListClass>(context, listen: false)
                          .checkBox(goalIndex);
                      if (goal.isDone) {
                        final player = AudioCache();
                        player.play('note7.wav');
                      }
                    },
                    isDone: goal.isDone,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ReorderableColumn(
                onReorder: (oldIndex, newIndex) {
                  // be sure you set, listen: false
                  Provider.of<GoalsListClass>(context, listen: false)
                      .updatStepPosition(goalIndex, oldIndex, newIndex);
                  print(oldIndex);
                  print(newIndex);
                },
                children: getSteps(),
                footer: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ListTile(
                        trailing: FloatingActionButton(
                          mini: true,
                          child: const Icon(
                            FontAwesomeIcons.plus,
                            size: 20,
                          ),
                          // add step
                          onPressed: addStep,
                        ),
                        title: TextField(
                          minLines: 1,
                          maxLines: 5,
                          controller: textEditingController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Add a Step',
                          ),
                          // add step
                          onSubmitted: (_) {
                            addStep();
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: <Widget>[
                          SingleGoalSlider(
                            key: ValueKey('slider'),
                            goalIndex: goalIndex,
                          ),
                          SingleGoalRepeatCard(
                            goalIndex: goalIndex,
                          ),
                          SingleGoalReminderCard(
                            goalIndex: goalIndex,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
