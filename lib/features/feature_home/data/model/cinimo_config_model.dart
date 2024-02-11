class CinimoConfig {
  Config? config;

  CinimoConfig({this.config});

  CinimoConfig.fromJson(Map<String, dynamic> json) {
    config = json['config'] != null ? Config.fromJson(json['config']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (config != null) {
      data['config'] = config!.toJson();
    }
    return data;
  }
}

class Config {
  String? baseUrl;
  String? fileUrl;
  String? telegram;
  String? instgram;
  String? iranDonateGetWay;
  String? irPicGetway;
  String? dollorDonateGetWay;
  String? dollorPicGateway;
  String? showBanner;
  String? bannerPictureUrl;
  String? bannerActionType;
  String? bannerActionData;
  bool? viewShow;
  bool? enableSubtitle;
  int? downloadFreeMaxium;
  bool? freeUserPaidVideo;

  Config(
      {this.baseUrl,
      this.fileUrl,
      this.telegram,
      this.instgram,
      this.iranDonateGetWay,
      this.irPicGetway,
      this.dollorDonateGetWay,
      this.dollorPicGateway,
      this.showBanner,
      this.bannerPictureUrl,
      this.bannerActionType,
      this.bannerActionData,
      this.viewShow,
      this.enableSubtitle,
      this.downloadFreeMaxium,
      this.freeUserPaidVideo});

  Config.fromJson(Map<String, dynamic> json) {
    baseUrl = json['baseUrl'];
    fileUrl = json['fileUrl'];
    telegram = json['telegram'];
    instgram = json['instgram'];
    iranDonateGetWay = json['iranDonateGetWay'];
    irPicGetway = json['irPicGetway'];
    dollorDonateGetWay = json['dollorDonateGetWay'];
    dollorPicGateway = json['dollorPicGateway'];
    showBanner = json['showBanner'];
    bannerPictureUrl = json['BannerPictureUrl'];
    bannerActionType = json['BannerActionType'];
    bannerActionData = json['BannerActionData'];
    viewShow = json['viewShow'];
    enableSubtitle = json['enableSubtitle'];
    downloadFreeMaxium = json['download_free_maximum'];
    freeUserPaidVideo = json['free_to_users_paid_videos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['baseUrl'] = baseUrl;
    data['fileUrl'] = fileUrl;
    data['telegram'] = telegram;
    data['instgram'] = instgram;
    data['iranDonateGetWay'] = iranDonateGetWay;
    data['irPicGetway'] = irPicGetway;
    data['dollorDonateGetWay'] = dollorDonateGetWay;
    data['dollorPicGateway'] = dollorPicGateway;
    data['showBanner'] = showBanner;
    data['BannerPictureUrl'] = bannerPictureUrl;
    data['BannerActionType'] = bannerActionType;
    data['BannerActionData'] = bannerActionData;
    data['viewShow'] = viewShow;
    data['enableSubtitle'] = enableSubtitle;
    data['downloadFreeMaxium'] = downloadFreeMaxium;
    data['free_to_users_paid_videos'] = freeUserPaidVideo;
    return data;
  }
}
