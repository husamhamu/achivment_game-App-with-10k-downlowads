import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:achivment_game/goal_widgets//goal_card.dart';
import 'package:provider/provider.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:achivment_game/models/goal_class.dart';

class GoalsList extends StatelessWidget {
  final Function onTap;

  GoalsList({this.onTap});

  @override
  Widget build(BuildContext context) {
    List<Widget> myGoals = [];

    List<Goal> _goals = Provider.of<GoalsListClass>(context).goals;

    // Widget widget = ListView.builder(
    //   itemBuilder: (context, index) {
    //     return Container();
    //   },
    //   itemCount: _goals.length(),
    // );
    List<Widget> _getGoals() {
      for (int index = 0; index < _goals.length; index++) {
        myGoals.add(
          GoalCard(
            key: ValueKey('${_goals[index].name} $index'),
            onTap: () {
              onTap(index);
            },
            name: _goals[index].name,
            isDone: _goals[index].isDone,
            onTapBox: () {
              //
              Provider.of<GoalsListClass>(context, listen: false)
                  .checkBox(index);
              if (_goals[index].isDone) {
                final player = AudioCache();
                player.play('note7.wav');
              }
            },
            showData: true,
            stepsNum: _goals[index].steps.length,
            repeat: _goals[index].repeat,
            goalIndex: index,
          ),
        );
      }
      return myGoals;
    }

    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        //
        print('old $oldIndex');
        print('new $newIndex');
        Provider.of<GoalsListClass>(context, listen: false)
            .updateGoalPosition(oldIndex, newIndex);
      },
      children: _getGoals(),
    );

    // return ListView.builder(
    //   itemBuilder: (context, index) {
    //     return GoalCard(
    //       key: ValueKey('${_goals[index].name} $index'),
    //       onTap: () {
    //         onTap(index);
    //       },
    //       name: _goals[index].name,
    //       isDone: _goals[index].isDone,
    //       onTapBox: () {
    //         //
    //         Provider.of<GoalsListClass>(context, listen: false).checkBox(index);
    //       },
    //       showData: true,
    //       stepsNum: _goals[index].steps.length,
    //       repeat: _goals[index].repeat,
    //       goalIndex: index,
    //     );
    //   },
    //   itemCount: _goals.length,
    // );
  }
}
