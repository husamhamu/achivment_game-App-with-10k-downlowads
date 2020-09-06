import 'package:achivment_game/constants.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function onTap;
  final int itemsNumber;

  HomeCard(
      {@required this.icon,
      @required this.text,
      @required this.onTap,
      @required this.itemsNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: k20RoundedRectangleBorder,
      child: ListTile(
        shape: k20RoundedRectangleBorder,
        onTap: onTap,
        leading: FittedBox(child: icon),
        trailing: Text(
          '$itemsNumber',
          style: const TextStyle(fontSize: 20),
        ),
        title: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
