import 'package:achivment_game/constants.dart';
import 'package:achivment_game/models/StartingTimeStorage.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:achivment_game/models/reward_class.dart';
import 'package:achivment_game/models/reward_list_class.dart';
import 'package:achivment_game/screens/rewards_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class RewardCard extends StatelessWidget {
  final Reward reward;
  final Function unlockReward;
  final Animation animation;
  final Function removeReward;
  RewardCard({
    @required this.reward,
    @required this.animation,
    @required this.unlockReward,
    @required this.removeReward,
  }); //  final int rewardIndex;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    void _notHavingEnoughPointsDialog(int neededPoints) async {
//      neededPoints = neededPoints == 0 ? reward.points : neededPoints;
      await showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Keep up the work!'),
          content: Text("You still need $neededPoints points"),
        ),
      );
    }

    void _unlockingRewardDialog() async {
      await showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Unlocking...'),
          elevation: 5,
          content: Text('This would cost you '
              '${reward.points} points'
              '\n Are you sure you want to unlock this?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            FlatButton(
              onPressed: () {
                unlockReward(reward);
                Navigator.pop(context);
              },
              child: const Text(
                'Unlock',
                style: const TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );
    }

    void _tryBuying() async {
      int boughtRewardsPoints = 0;
      List<Reward> boughtRewards =
          Provider.of<RewardList>(context, listen: false).boughtRewards;
      if (boughtRewards.length > 0) {
        for (Reward reward in boughtRewards) {
          boughtRewardsPoints += reward.points;
        }
      }
      boughtRewardsPoints += reward.points;
      int numberOftheCurrentWeek =
          Provider.of<StartingTimeStorage>(context, listen: false)
              .numberOftheCurrentWeek();
      int totalAchievement = Provider.of<GoalsListClass>(context, listen: false)
          .getTotalAchievement(numberOftheCurrentWeek);
      if (totalAchievement > boughtRewardsPoints) {
        _unlockingRewardDialog();
      } else {
        _notHavingEnoughPointsDialog(boughtRewardsPoints - totalAchievement);
      }
    }

    void showRemoveRewardDilog() async {
      await showDialog(
        context: context,
        child: AlertDialog(
            elevation: 10,
            title: const Text('Are you sure?'),
            content: Text('"${reward.title}" will be permanently deleted.'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  removeReward(reward);
                },
                child: const Text(
                  'DELETE',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ]),
      );
    }

    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          elevation: 10,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            //deleting the reward
            onLongPress: showRemoveRewardDilog,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Image.file(
                        File(reward.filePath),
                        fit: BoxFit.cover,
                        height: screenHeight - (screenHeight * 0.68),
                        width: double.infinity,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      width: double.infinity,
                      height: screenHeight - (screenHeight * 0.68),
                      child: FittedBox(
                        child: Icon(
                          Icons.lock,
                          size: 5,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: screenWidth * 0.1,
                      left: screenWidth * 0.02,
                      right:
                          (screenWidth * 0.3) - reward.title.length.toDouble(),
                      child: Container(
                        margin: EdgeInsets.only(right: screenWidth * 0.3),
                        padding: EdgeInsets.all(5),
                        color: Colors.black54,
                        child: Text(
                          reward.title,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.02,
                      bottom: screenWidth * 0.02,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.monetization_on,
                              size: 25,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Text(
                              '${reward.points} points',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton.icon(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      onPressed: _tryBuying,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Colors.lightGreen,
                      icon: Icon(
                        Icons.lock_open,
                        color: Colors.white,
                        size: 25,
                      ),
                      label: Text(
                        'Unlock',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Stack(
//                    children: <Widget>[
//                      Container(
//                        decoration: BoxDecoration(
//                          color: Colors.lightGreen,
//                          borderRadius: BorderRadius.only(
//                            topRight: Radius.circular(10),
//                            bottomRight: Radius.circular(10),
//                          ),
//                        ),
//                        padding: EdgeInsets.only(
//                            left: 10, top: 3, right: 5, bottom: 3),
//                        margin: EdgeInsets.only(left: 30, top: 8),
//                        child: Text(
//                          '${Provider.of<RewardList>(context).getPoints(rewardIndex)} points',
//                          style: TextStyle(fontSize: 18, color: Colors.white),
//                        ),
//                      ),
//                      CircleAvatar(
//                        backgroundColor: Colors.lightGreen,
//                        child: Icon(
//                          Icons.attach_money,
//                          color: Colors.white,
//                          size: 25,
//                        ),
//                      ),
//                    ],
//                  ),
