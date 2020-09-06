import 'package:achivment_game/models/StartingTimeStorage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CircularProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double percentageDay() {
//      int daysNum= StartingTimeStorage.numberOfTheWeeks*7 +StartingTimeStorage.numberOfTheWeeks-1;
    }

    double getValue() {
      int maxDaysNum = Provider.of<StartingTimeStorage>(context, listen: false)
              .numberOfTheWeeks *
          7;
      double percentage = (1 / maxDaysNum);
      int numberOfTheCurrentWeek =
          Provider.of<StartingTimeStorage>(context, listen: false)
              .numberOfTheCurrentDay();
      if (numberOfTheCurrentWeek != -1) {
        return (percentage * numberOfTheCurrentWeek);
      } else {
        return 0;
      }
    }

    final left = MediaQuery.of(context).orientation != Orientation.landscape
        ? MediaQuery.of(context).size.width * 0.027
        : MediaQuery.of(context).size.width * 0.018;
    final top = MediaQuery.of(context).orientation != Orientation.landscape
        ? MediaQuery.of(context).size.width * 0.037
        : MediaQuery.of(context).size.width * 0.022;
    return Container(
      padding: const EdgeInsets.all(15),
      height: MediaQuery.of(context).size.width * 0.7,
      width: MediaQuery.of(context).size.width * 0.5,
      child: FittedBox(
        child: Stack(
          children: <Widget>[
            CircularProgressIndicator(
              strokeWidth: 1,
              value: getValue(),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              backgroundColor: Colors.black12,
            ),
            Positioned(
              left: left,
              top: top,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Day ${Provider.of<StartingTimeStorage>(context, listen: false).numberOfTheCurrentDay()}',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 5,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
