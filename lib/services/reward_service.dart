class RewardService {
  static int calculateContributionReward(bool isUnique) {
    return isUnique ? 100 : 20;
  }

  static int calculateUsageReward(int accessCount) {
    return accessCount ~/ 10;
  }

  static int calculateReviewReward(int positiveReviews) {
    return positiveReviews * 5;
  }
}
