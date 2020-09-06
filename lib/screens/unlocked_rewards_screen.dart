import 'package:achivment_game/models/reward_list_class.dart';
import 'package:achivment_game/other_widgets/bought_reward_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnlockedRewardsScreen extends StatefulWidget {
  final Text title;

  UnlockedRewardsScreen({this.title});

  @override
  _UnlockedRewardsScreenState createState() => _UnlockedRewardsScreenState();
}

class _UnlockedRewardsScreenState extends State<UnlockedRewardsScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    int length =
        Provider.of<RewardList>(context, listen: false).boughtRewards.length -
            1;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<Widget> boughtRewards = [];
//we need to let Animated switcher think it has 2 different children
    Widget getChild() {
      bool change = false;
      for (int i = length; i >= 0; i--) {
        if (change) {
          boughtRewards.add(BoughtRewardCard(
            rewardIndex: i,
          ));
        } else {
          boughtRewards.add(Container(
            width: double.infinity,
            child: BoughtRewardCard(
              rewardIndex: i,
            ),
          ));
        }
        change = !change;
      }
      return boughtRewards[index];
    }

    return AlertDialog(
      title: widget.title != null ? widget.title : Text('Unlocked rewards'),
      content: Builder(
        builder: (context) {
          return Container(
            height: screenHeight * 0.49,
            width: screenWidth,
            child: Column(
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      child: child,
                      scale: animation,
                    );
                  },
                  child: getChild(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
//                    if (length > 0 && index > 0)
                    FlatButton(
                      onPressed: () {
                        if (index > 0) {
                          setState(() {
                            index--;
                          });
                        }
                      },
                      child: Icon(Icons.navigate_before),
                    ),
//                    if (length > 0)
                    FlatButton(
                      onPressed: () {
                        if (index < length) {
                          setState(() {
                            index++;
                          });
                        }
                      },
                      child: const Icon(Icons.navigate_next),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
