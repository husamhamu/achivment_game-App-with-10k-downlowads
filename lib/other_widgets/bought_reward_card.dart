import 'dart:io';

import 'package:achivment_game/models/reward_list_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoughtRewardCard extends StatelessWidget {
  final int rewardIndex;

  BoughtRewardCard({this.rewardIndex});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        elevation: 10,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          onLongPress: () {
            print('go goo');
          },
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image.file(
                      File(Provider.of<RewardList>(context)
                          .getBoughtRewardFilePatht(rewardIndex)),
                      fit: BoxFit.cover,
                      height: screenHeight - (screenHeight * 0.68),
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: (screenWidth * 0.1) -
                        Provider.of<RewardList>(context)
                            .getBoughtRewardTitle(rewardIndex)
                            .length
                            .toDouble(),
                    child: Container(
                      margin: EdgeInsets.only(right: screenWidth * 0.3),
                      padding: const EdgeInsets.all(5),
                      color: Colors.black54,
                      child: Text(
                        Provider.of<RewardList>(context)
                            .getBoughtRewardTitle(rewardIndex),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.monetization_on,
                            size: 30,
                            color: Colors.white,
                          ),
                          Text(
                            '${Provider.of<RewardList>(context).getBoughtRewardPoints(rewardIndex)} points',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
