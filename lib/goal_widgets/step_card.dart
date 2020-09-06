import 'package:achivment_game/models/golas_list_class.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:achivment_game/goal_widgets//rounded_check_box.dart';
import 'package:provider/provider.dart';

class StepCard extends StatefulWidget {
//  final Function onTapBox;
  final bool isDone;
  final String name;
//  final Function onTap;
  final int stepIndex;
  final int goalIndex;
  final Key key;
  final Function onTap;
  final Function onLongPress;
  StepCard({
    @required this.isDone,
    @required this.name,
    @required this.stepIndex,
    @required this.goalIndex,
    @required this.key,
    @required this.onTap,
    this.onLongPress,
  });

  @override
  _StepCardState createState() => _StepCardState();
}

class _StepCardState extends State<StepCard> {
  final textController = TextEditingController();
  FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    bool updateName = Provider.of<GoalsListClass>(context, listen: false)
        .stepNameBoolean(widget.goalIndex, widget.stepIndex);
    textController.text = widget.name;
    return Dismissible(
      key: ValueKey(widget.stepIndex),
      onDismissed: (direction) {
        Provider.of<GoalsListClass>(context, listen: false)
            .deleteStep(widget.goalIndex, widget.stepIndex);
      },
      background: Container(
        color: Colors.redAccent,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.delete,
                color: Colors.black38,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        key: widget.key,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  widget.name,
                  maxLines: 5,
                  style: TextStyle(
                      fontSize: 18,
                      decoration: widget.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
              ),
//editing step name
//under development because some errors occured
              // child: GestureDetector(
              //   onTap: () {
              //     Provider.of<GoalsListClass>(context, listen: false)
              //         .updateStepNameBoolean(
              //             widget.goalIndex, widget.stepIndex, true);
              //   },
              //   child: Padding(
              //     padding: updateName
              //         ? const EdgeInsets.only(right: 15, left: 15)
              //         : const EdgeInsets.symmetric(
              //             vertical: 15, horizontal: 15),
              //     child: Provider.of<GoalsListClass>(context)
              //             .stepNameBoolean(widget.goalIndex, widget.stepIndex)
              //         ? TextField(
              //             focusNode: _focusNode,
              //             autofocus: true,
              //             controller: textController,
              //             decoration: InputDecoration(),
              //             minLines: 1,
              //             maxLines: 5,
              //             keyboardType: TextInputType.text,
              //             onSubmitted: (_) {
              //               // update the stepName
              //               if (GoalsListClass.checkString(
              //                   textController.text)) {
              //                 Provider.of<GoalsListClass>(context,
              //                         listen: false)
              //                     .updateStepName(widget.goalIndex,
              //                         widget.stepIndex, textController.text);
              //               }
              //
              //               ///we do this inside the updateStepName() so we dont acually update
              //               ///the UI twice
              //               //change the widget to be a text again
              //               // Provider.of<GoalsListClass>(context, listen: false)
              //               //     .updateStepNameBoolean(
              //               //         widget.goalIndex, widget.stepIndex, false);
              //             },
              //           )
              //         : Text(
              //             widget.name,
              //             maxLines: 5,
              //             style: TextStyle(
              //                 fontSize: 16,
              //                 decoration: widget.isDone
              //                     ? TextDecoration.lineThrough
              //                     : TextDecoration.none),
              //           ),
              //   ),
              // ),
            ),
            RoundedCheckBox(
              // check a step
              onTap: () {
                Provider.of<GoalsListClass>(context, listen: false)
                    .checkStep(widget.goalIndex, widget.stepIndex);
                print(widget.isDone);
                //we are dont need acually to listen to the value
                // Provider.of<GoalsListClass>(context, listen: false).goals[widget.goalIndex]
                //     .steps[widget.stepIndex].isDone;
                if (!widget.isDone) {
                  final player = AudioCache();
                  player.play('note7.wav');
                }
              },
              isDone: widget.isDone,
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
    );
  }
}
