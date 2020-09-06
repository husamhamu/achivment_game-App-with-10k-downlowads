import 'package:achivment_game/goal_widgets/step_card.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:achivment_game/models/step_class.dart';

class StepList extends StatelessWidget {
  final int goalIndex;

  StepList({@required this.goalIndex});

  @override
  Widget build(BuildContext context) {
    List<StepClass> steps =
        Provider.of<GoalsListClass>(context).goals[goalIndex].steps;
    List<Widget> stepCards = [];
    final stepsProvider = Provider.of<GoalsListClass>(context).goals[goalIndex];
    List<Widget> getSteps() {
      int index = 0;
      for (int stepIndex = 0; stepIndex < steps.length; stepIndex++) {
        stepCards.add(
          StepCard(
            key: ValueKey('${stepsProvider.steps[index].name} $index'),
            stepIndex: stepIndex,
            goalIndex: goalIndex,
            name: stepsProvider.steps[index].name,
            isDone: stepsProvider.steps[index].isDone,
            onTap: () {
              print(stepIndex);
            },
          ),
        );
        index++;
      }

      return stepCards;
    }

    return Container();
  }
}

//child: ListView.builder(
//itemBuilder: (context, index) {
//return StepCard(
//// must use a provider that is at high level
//// if i have passed the Goal instead of the goalIndex i will get into
//// the problem that the dispose() method would be called on the Goal when going back
//// to the goals_screen
//name: goal.goals[goalIndex].steps[index].name,
//isDone: goal.goals[goalIndex].steps[index].isDone,
//onTapBox: () {
////remember you need to notify the goalsList class
//// not goal class
//goal.goals[goalIndex].checkStep(index);
//goal.notify();
//},
//onTap: () {
//// delete step
//},
//);
//},
//itemCount: goal.goals[goalIndex].stepGetLenght(),
//),
