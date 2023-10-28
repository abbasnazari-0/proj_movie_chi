import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_chi/core/ad/ad_abstracts.dart';
import 'package:movie_chi/core/models/admob-models.dart';
import 'package:movie_chi/core/utils/constants.dart';

import '../params/admob-ids-getter.dart';

class AdInitilzer implements MyRewardedAd, MyInterstitialAd, MyBannerAd {
  RewardedInterstitialAd? _rewardeInterstitialdAd;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  AdmobData adModel = AdmobDataGetter.getAdmobIds();

  void init() {
    // fill your ad ids
    AdmobData adModel = AdmobDataGetter.getAdmobIds();
    print("adModel is ${adModel.toJson()}");
  }

  @override
  Future<void> disposeRewarded() {
    return _rewardeInterstitialdAd?.dispose() ?? Future.value();
  }

  @override
  Future<void> loadRewarded() async {
    if (!Constants.allowToShowAd()) return;
    await RewardedInterstitialAd.load(
      adUnitId: "ca-app-pub-3457973144070792/4840822894",
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _rewardeInterstitialdAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedInterstitialAd failed to load: $error');
          if (_rewardeInterstitialdAd != null) {
            _rewardeInterstitialdAd?.dispose();
          }
          loadInterstitial();
        },
      ),
    );
  }

  @override
  Future<void> showRewarded() async {
    if (!Constants.allowToShowAd()) return;
    if (_rewardeInterstitialdAd == null && _interstitialAd == null) {
      await loadRewarded();
    }
    if (_rewardeInterstitialdAd != null && _interstitialAd == null) {
      await _rewardeInterstitialdAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint(
            '$ad with reward $RewardItem(amount: ${reward.amount}, type: ${reward.type}');
      });
    }
    if (_rewardeInterstitialdAd == null && _interstitialAd != null) {
      await showInterstitial();
    }
    if (_rewardeInterstitialdAd != null && _interstitialAd != null) {
      await _rewardeInterstitialdAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint(
            '$ad with reward $RewardItem(amount: ${reward.amount}, type: ${reward.type}');
      });
    }
  }

  @override
  Future<void> disposeBanner() async {
    if (!Constants.allowToShowAd()) return;
    await _bannerAd?.dispose();
  }

  @override
  Future<void> disposeInterstitial() async {
    if (!Constants.allowToShowAd()) return;
    await _interstitialAd?.dispose();
  }

  @override
  Future<void> loadBanner() async {
    if (!Constants.allowToShowAd()) return;
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-3457973144070792/8921019776",
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');

          // setState(() {
          //   _isLoaded = true;
          // });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Future<void> loadInterstitial() async {
    if (!Constants.allowToShowAd()) return;
    await InterstitialAd.load(
        adUnitId: "ca-app-pub-3457973144070792/7416366413",
        //ممكن تغير ال id
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
            ad.show();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
            if (_interstitialAd != null) {
              _interstitialAd?.dispose();
            }
          },
        ));
  }

  @override
  Future<void> showBanner() async {
    if (!Constants.allowToShowAd()) return;
    // await _bannerAd?.load();
  }

  @override
  Future<void> showInterstitial() async {
    if (!Constants.allowToShowAd()) return;
    await _interstitialAd?.show();
  }
}
