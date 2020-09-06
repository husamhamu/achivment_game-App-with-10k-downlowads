import 'package:achivment_game/constants.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:achivment_game/models/StartingTimeStorage.dart';

class WeeklyTrackingScreen extends StatelessWidget {
  static final String id = 'WeeklyTracking';
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, myScrollContrller) {
        return Container(
          color: const Color(0xFF767676),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              controller: myScrollContrller,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: TrackingTable(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TrackingTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<DataRow> listOfDataRow = [];
    //getting the number of the currentWeek
    int numberOftheCurrentWeek =
        Provider.of<StartingTimeStorage>(context, listen: false)
            .numberOftheCurrentWeek();
    int numberOfTheWeek =
        Provider.of<StartingTimeStorage>(context, listen: false)
            .numberOfTheWeek();

    DateTime getStartingTime() {
      if (Provider.of<StartingTimeStorage>(context, listen: false)
              .startingTime !=
          null) {
        return Provider.of<StartingTimeStorage>(context, listen: false)
            .startingTime;
      } else {
        return DateTime.now();
      }
    }

    List months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec',
    ];
    String dateCellText(DateTime dateTime1) {
      // if the week period like [28-4] we will name the month according to the 4's month
      return '${dateTime1.day} - ${dateTime1.add(Duration(days: 6)).day} '
          '${months[dateTime1.month]}';
    }

    int getTotalAchievemnt(int numOfWeeks) {
      if (numberOftheCurrentWeek >= numOfWeeks + 1) {
        int a = 0;
        for (int i = 1; i <= numOfWeeks + 1; i++) {
          a += Provider.of<GoalsListClass>(context).getWeekAchievement(i);
        }
        return a;
      } else {
        return 0;
      }
    }

    List<DataRow> getRows() {
      DateTime dateTime = getStartingTime();
      int weekNum = 1;
      for (int i = 0; i < numberOfTheWeek; i++) {
        listOfDataRow.add(
          DataRow(
            selected: weekNum == numberOftheCurrentWeek ? true : false,
            cells: [
              DataCell(
                Text(
                  '$weekNum. [${dateCellText(dateTime)}]',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              DataCell(
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    '${Provider.of<GoalsListClass>(context).getWeekAchievement(weekNum)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                onTap: () {
                  //
                },
              ),
              DataCell(
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    '${getTotalAchievemnt(i)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                onTap: () {
//                  print('455 $i');
                },
              ),
            ],
          ),
        );
        dateTime = dateTime.add(Duration(days: 7));
        weekNum++;
      }
      return listOfDataRow;
    }

    return DataTable(
      columns: [
        DataColumn(
            label: Text(
          'Week',
          style: kTableColumnTextStyle,
        )),
        DataColumn(
            label: Text(
          '    Weekly \nachievement',
          style: kTableColumnTextStyle,
        )),
        DataColumn(
            label: Text(
          '       Total \nachievement',
          style: kTableColumnTextStyle,
        )),
      ],
      rows: getRows(),
    );
  }
}
