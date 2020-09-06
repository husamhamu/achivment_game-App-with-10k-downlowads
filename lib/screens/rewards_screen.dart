import 'dart:io';

import 'package:achivment_game/constants.dart';
import 'package:achivment_game/models/StartingTimeStorage.dart';
import 'package:achivment_game/models/golas_list_class.dart';
import 'package:achivment_game/models/reward_class.dart';
import 'package:achivment_game/models/reward_list_class.dart';
import 'package:achivment_game/other_widgets/reward_card.dart';
import 'package:achivment_game/screens/add_rewards_screen.dart';
import 'package:achivment_game/screens/unlocked_rewards_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RewardsScreen extends StatelessWidget {
  static final String id = 'RewardsScreen';
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void viewBoughtRewards() async {
      await showDialog(
        context: context,
        child: UnlockedRewardsScreen(),
      );
    }

    void congregationDialog() async {
      await showDialog(
        context: context,
        child: UnlockedRewardsScreen(
          title: const Text(
            'Congregations!',
            style: const TextStyle(color: Colors.green),
          ),
        ),
      );
    }

    void unlockReward(Reward reward) {
      //removing the item from the AnimatedList
      int rewardIndex = Provider.of<RewardList>(context, listen: false)
          .rewards
          .indexOf(reward);
      listKey.currentState.removeItem(rewardIndex, (context, animation) {
        return RewardCard(
          reward: reward,
          animation: animation,
          unlockReward: (_) {},
          removeReward: (_) {},
        );
      });
      //removing the item from the list
      Provider.of<RewardList>(context, listen: false).unlockReward(rewardIndex);
      Future.delayed(Duration(milliseconds: 700)).then((value) {
        congregationDialog();
      });
    }

    void insertReward() {
      int index =
          Provider.of<RewardList>(context, listen: false).rewards.length > 0
              ? Provider.of<RewardList>(context, listen: false).rewards.length -
                  1
              : 0;
      print(index);
      listKey.currentState.insertItem(index);
    }

    void removeReward(Reward reward) {
      int rewardIndex = Provider.of<RewardList>(context, listen: false)
          .rewards
          .indexOf(reward);
      listKey.currentState.removeItem(rewardIndex, (context, animation) {
        return RewardCard(
            reward: reward,
            animation: animation,
            unlockReward: (_) {},
            removeReward: (_) {});
      });
      Provider.of<RewardList>(context, listen: false).removeReward(reward);
    }

    int availablePoints() {
      int availablePoints = 0;
      List<Reward> boughtRewards =
          Provider.of<RewardList>(context, listen: false).boughtRewards;
      if (boughtRewards.length > 0) {
        for (Reward reward in boughtRewards) {
          availablePoints += reward.points;
        }
      }
      //getting the number of the currentWeek
      int numberOftheCurrentWeek =
          Provider.of<StartingTimeStorage>(context, listen: false)
              .numberOftheCurrentWeek();
      //getting the total achievement
      availablePoints = Provider.of<GoalsListClass>(context)
              .getTotalAchievement(numberOftheCurrentWeek) -
          availablePoints;
      return availablePoints;
    }

    return Scaffold(
      backgroundColor: kRewardsScreenColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddRewardsScreen(
              addReward: insertReward,
            );
          }));
        },
        backgroundColor: kRewardsScreenColor,
        child: const Icon(
          FontAwesomeIcons.plus,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: BackButton(
                onPressed: () {
                  // take the user back
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                right: 20,
                left: 20,
                bottom: Provider.of<StartingTimeStorage>(context, listen: false)
                            .startingTime ==
                        null
                    ? 20
                    : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    child: Icon(
                      FontAwesomeIcons.gift,
                      color: kRewardsScreenColor,
                      size: 40,
                    ),
                    backgroundColor: Colors.white,
                    radius: 30,
                  ),
                  Text(
                    'My Rewards',
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  if (Provider.of<StartingTimeStorage>(context, listen: false)
                          .startingTime !=
                      null)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Provider.of<RewardList>(context)
                                    .boughtRewards
                                    .length >
                                0
                            ? 0
                            : 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Available achieved points: ${availablePoints()}',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            maxLines: 2,
                          ),
                          Visibility(
                            visible: Provider.of<RewardList>(context)
                                        .boughtRewards
                                        .length >
                                    0
                                ? true
                                : false,
                            child: RawMaterialButton(
                              elevation: 10,
                              highlightElevation: 10,
                              //view bought rewards
                              onPressed: viewBoughtRewards,
                              child: Icon(
                                Icons.remove_red_eye,
                                color: kRewardsScreenColor,
                                size: 20,
                              ),
                              shape: const CircleBorder(),
                              constraints: BoxConstraints.tightFor(
                                  width: 36.0, height: 36.0),
                              fillColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: AnimatedList(
                      key: listKey,
                      initialItemCount:
                          Provider.of<RewardList>(context).rewards.length,
                      itemBuilder: (context, index, animation) {
                        return RewardCard(
                          reward:
                              Provider.of<RewardList>(context).rewards[index],
                          animation: animation,
                          unlockReward: unlockReward,
                          removeReward: removeReward,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
