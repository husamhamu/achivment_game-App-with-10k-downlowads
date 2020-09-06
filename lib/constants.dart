import 'package:flutter/material.dart';

final DateTime now = DateTime.now();

final DateTime kLaterOn6AM = DateTime(now.year, now.month, now.day, 6, 0);

final DateTime kLaterOn9AM = DateTime(now.year, now.month, now.day, 9, 0);

final DateTime kLaterOn12AM = DateTime(now.year, now.month, now.day, 12, 0);

final DateTime kLaterOn16PM = DateTime(now.year, now.month, now.day, 16, 0);

final DateTime kLaterOn21PM = DateTime(now.year, now.month, now.day, 21, 0);

final kTrackingScreenColour = const Color(0xFF4AA079);

final kTableColumnTextStyle =
    TextStyle(fontSize: 20, color: kTrackingScreenColour);

final k20RoundedRectangleBorder = const RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20.0),
    bottomRight: Radius.circular(20.0),
  ),
);

final kTextStyleBlue = const TextStyle(color: Colors.blue);

final kRewardsScreenColor = const Color(0xFFDE5C7A);

final k15RoundedRectangleBorder = const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(15)),
);

const TextStyle kAboutScreenTextStyle =
    const TextStyle(color: Colors.white, fontSize: 16);
List<String> kListOfDaysName = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday'
];

const TextStyle kTextStyle = const TextStyle(fontSize: 20);
//final screenWidth = MediaQuery.of(context).size.width;
//final screenHeight = MediaQuery.of(context).size.height;
