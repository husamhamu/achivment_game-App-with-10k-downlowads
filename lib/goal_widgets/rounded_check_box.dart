import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundedCheckBox extends StatelessWidget {
  final Function onTap;
  final bool isDone;

  RoundedCheckBox({@required this.onTap, @required this.isDone});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // check the box
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDone ? Colors.blue : Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: isDone
              ? const Icon(
                  FontAwesomeIcons.check,
                  size: 25.0,
                  color: Colors.white,
                )
              : const Icon(
                  FontAwesomeIcons.checkCircle,
                  size: 30.0,
                  color: Colors.blue,
                ),
        ),
      ),
    );
  }
}
