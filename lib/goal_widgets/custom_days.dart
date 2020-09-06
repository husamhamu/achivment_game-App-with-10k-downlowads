import 'package:flutter/material.dart';
import 'package:achivment_game/models/goal_class.dart';

class CustomDay extends StatelessWidget {
  final Function onPressed;
  final List<Days> list;
  CustomDay({
    @required this.onPressed,
    @required this.list,
  });
  @override
  Widget build(BuildContext context) {
    // add the current day if there is no elements
    int dayNum = DateTime.now().weekday;
    if (list.length < 1) {
      list.add(Days.values[dayNum]);
    }

    print(list);
    //list of items if the user removed them than canceled so we will add them again
    List<Days> tempListIfCancelToAdd = [];

    //list of items if the user added them than canceled so we will remove them
    List<Days> tempListIfCancelToRemove = [];
    tempListIfCancelToRemove.add(Days.values[dayNum]);

    bool addOrRemove(Days day, bool isChosenBefore) {
      if ((list.length == 1) & isChosenBefore) {
//        print(list);
        return false;
      } else {
        if (list.contains(day)) {
          list.remove(day);
          if (!tempListIfCancelToAdd.contains(day)) {
            tempListIfCancelToAdd.add(day);
          }
          return true;
        } else {
          list.add(day);
          if (!tempListIfCancelToRemove.contains(day)) {
            tempListIfCancelToRemove.add(day);
          }
//          print(list);
          return true;
        }
      }
    }

    return AlertDialog(
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.all(Radius.circular(10.0)),
//      ),
      title: const Text('Repeat every ..'),
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
            width: width - (width * 0.2),
            height: height - (height * 0.82),
            child: GridView(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 60,
                childAspectRatio: 1,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              children: <Widget>[
                //   static const Sunday = Day(1);
                //     static const Monday = Day(2);
                // static const Tuesday = Day(3);
                // static const Wednesday = Day(4);
                // static const Thursday = Day(5);
                // static const Friday = Day(6);
                // static const Saturday = Day(7);
                DayD(
                  name: 'MON',
                  onTap: (isChosenBefore) {
                    return addOrRemove(Days.Monday, isChosenBefore);
                  },
                  isChosenBefor: list.contains(Days.Monday),
                ),
                DayD(
                  name: 'TUE',
                  onTap: (isChosenBefore) {
                    return addOrRemove(Days.Tuesday, isChosenBefore);
                  },
                  isChosenBefor: list.contains(Days.Tuesday),
                ),
                DayD(
                  name: 'WED',
                  onTap: (isChosenBefore) {
                    return addOrRemove(Days.Wednesday, isChosenBefore);
                  },
                  isChosenBefor: list.contains(Days.Wednesday),
                ),
                DayD(
                  name: 'THU',
                  onTap: (isChosenBefore) {
                    return addOrRemove(Days.Thursday, isChosenBefore);
                  },
                  isChosenBefor: list.contains(Days.Thursday),
                ),
                DayD(
                  name: 'FRI',
                  onTap: (isChosenBefore) {
                    return addOrRemove(Days.Friday, isChosenBefore);
                  },
                  isChosenBefor: list.contains(Days.Friday),
                ),
                DayD(
                  name: 'SAT',
                  onTap: (isChosenBefore) {
                    return addOrRemove(Days.Saturday, isChosenBefore);
                  },
                  isChosenBefor: list.contains(Days.Saturday),
                ),
                DayD(
                  name: 'SUN',
                  onTap: (isChosenBefore) {
                    return addOrRemove(Days.Sunday, isChosenBefore);
                  },
                  isChosenBefor: list.contains(Days.Sunday),
                ),
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            // cancel
            print('temp list $tempListIfCancelToAdd');
            for (Days day in tempListIfCancelToAdd) {
              if (!list.contains(day)) {
                list.add(day);
              }
            }

            for (Days day in tempListIfCancelToRemove) {
              if (list.contains(day)) {
                list.remove(day);
              }
            }

            print('list before canceling $list');
            Navigator.pop(context);
          },
          child: const Text(
            'cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        FlatButton(
          onPressed: () {
            //return the chosen days
            print('list before done $list');

            Navigator.pop(context);
            onPressed(list);
          },
          child: const Text('done'),
        ),
      ],
    );
  }
}

class DayD extends StatefulWidget {
  final String name;
  final Function onTap;
  bool isChosenBefor;
  DayD({
    @required this.name,
    @required this.onTap,
    this.isChosenBefor,
  });

  @override
  _DayDState createState() => _DayDState();
}

class _DayDState extends State<DayD> {
  bool isWhite = true;

  @override
  Widget build(BuildContext context) {
    isWhite = widget.isChosenBefor;
    return InkWell(
      onTap: () {
        if (widget.onTap(widget.isChosenBefor)) {
          setState(() {
            widget.isChosenBefor = !widget.isChosenBefor;
          });
        }
      },
      borderRadius: const BorderRadius.all(Radius.circular(45)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(45)),
          color: widget.isChosenBefor ? Colors.lightBlueAccent : Colors.white,
          border: Border.all(
            color: Colors.lightBlueAccent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(widget.name),
        ),
      ),
    );
  }
}
