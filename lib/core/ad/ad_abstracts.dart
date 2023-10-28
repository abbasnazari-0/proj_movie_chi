abstract class MyRewardedAd {
  Future<void> loadRewarded();
  Future<void> showRewarded();
  Future<void> disposeRewarded();
}

abstract class MyBannerAd {
  Future<void> loadBanner();
  Future<void> showBanner();
  Future<void> disposeBanner();
}

abstract class MyInterstitialAd {
  Future<void> loadInterstitial();
  Future<void> showInterstitial();
  Future<void> disposeInterstitial();
}
