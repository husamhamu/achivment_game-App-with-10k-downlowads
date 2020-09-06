import 'package:flutter/material.dart';

class CleanWidget extends StatelessWidget {
  final Function onTap;
  CleanWidget({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: const Icon(
          Icons.clear,
          size: 15,
          color: Colors.lightBlueAccent,
        ),
      ),
    );
  }
}
