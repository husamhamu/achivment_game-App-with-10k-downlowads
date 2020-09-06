import 'package:achivment_game/helpers/db_helper.dart';
import 'package:achivment_game/models/reward_class.dart';
import 'package:flutter/material.dart';

class RewardList extends ChangeNotifier {
  List<Reward> _rewards;
  List<Reward> _boughtRewards;
  int rewardsId = 0;

  RewardList() {
    this._rewards = [];
    this._boughtRewards = [];
  }

  void addReward(int points, String title, String filePath) async {
    print('points: $points, title: $title, pathFile: $filePath');
    if (filePath != null && title != null && points > 0 && points < 1000) {
      _rewards.add(Reward(rewardsId, title, points, filePath));
      rewardsId++;
      notifyListeners();
      await DBHelper.addReward(_rewards[_rewards.length - 1]);
    }
  }

  String getTitel(int rewardIndex) {
    return _rewards[rewardIndex].title;
  }

  String getBoughtRewardTitle(int rewardIndex) {
    return _boughtRewards[rewardIndex].title;
  }

  String getFilePatht(int rewardIndex) {
    return _rewards[rewardIndex].filePath;
  }

  String getBoughtRewardFilePatht(int rewardIndex) {
    return _boughtRewards[rewardIndex].filePath;
  }

  int getPoints(int rewardIndex) {
    return _rewards[rewardIndex].points;
  }

  int getBoughtRewardPoints(int rewardIndex) {
    return _boughtRewards[rewardIndex].points;
  }

  void unlockReward(int rewardIdex) async {
    if (rewardIdex < _rewards.length) {
      _updateIsBought(rewardIdex);
      Reward reward = _rewards[rewardIdex];
      _rewards.removeAt(rewardIdex);
      _boughtRewards.add(reward);
      notifyListeners();
      await DBHelper.updateRewardIsBought(reward);
    }
  }

  void _updateIsBought(int rewardIndex) {
    _rewards[rewardIndex].isBought = !_rewards[rewardIndex].isBought;
  }

  void retrievingData(List<Reward> rewards) {
    if (rewards != null) {
      //don't forget to update rewardsId so when we add more rewards we give a new id
      //that depends on the previous one
      if (rewards.length > 0) {
        rewardsId = rewards.length;
        for (Reward reward in rewards) {
          if (reward.isBought) {
            _boughtRewards.add(reward);
          } else {
            _rewards.add(reward);
          }
        }
      } else {
        _rewards = [];
        _boughtRewards = [];
      }
    }
    notifyListeners();
  }

  void removeReward(Reward reward) async {
    if (_rewards.contains(reward)) {
      int rewardId = reward.id;
      _rewards.remove(reward);
      rewardsId--;
      notifyListeners();
      await DBHelper.deleteReward(rewardId);
    }
  }

  List<Reward> get rewards => List.unmodifiable(_rewards);

  List<Reward> get boughtRewards => List.unmodifiable(_boughtRewards);

  void restart() async {
    _rewards = [];
    _boughtRewards = [];
    rewardsId = 0;
    await DBHelper.deleteAllRewards();
    notifyListeners();
  }
}
