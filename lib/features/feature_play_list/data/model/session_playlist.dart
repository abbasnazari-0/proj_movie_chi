class SessionModel {
  String? status;
  String? code;
  String? message;
  List<Eposiod>? data;

  SessionModel({this.status, this.code, this.message, this.data});

  SessionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Eposiod>[];
      json['data'].forEach((v) {
        data!.add(Eposiod.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Eposiod {
  String? title;
  List<EpisoidsData>? episoids;

  Eposiod({this.title, this.episoids});

  Eposiod.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['episoids'] != null) {
      episoids = <EpisoidsData>[];
      json['episoids'].forEach((v) {
        episoids!.add(EpisoidsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (episoids != null) {
      data['episoids'] = episoids!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EpisoidsData {
  String? title;
  String? qualityId;
  String? id;
  String? quality240;
  String? quality360;
  String? quality480;
  String? quality720;
  String? quality1080;
  String? quality1440;
  String? quality2160;
  String? quality4320;

  EpisoidsData(
      {this.title,
      this.qualityId,
      this.id,
      this.quality240,
      this.quality360,
      this.quality480,
      this.quality720,
      this.quality1080,
      this.quality1440,
      this.quality2160,
      this.quality4320});

  EpisoidsData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    qualityId = json['quality_id'];
    id = json['id'];
    quality240 = json['quality_240'];
    quality360 = json['quality_360'];
    quality480 = json['quality_480'];
    quality720 = json['quality_720'];
    quality1080 = json['quality_1080'];
    quality1440 = json['quality_1440'];
    quality2160 = json['quality_2160'];
    quality4320 = json['quality_4320'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['quality_id'] = qualityId;
    data['id'] = id;
    data['quality_240'] = quality240;
    data['quality_360'] = quality360;
    data['quality_480'] = quality480;
    data['quality_720'] = quality720;
    data['quality_1080'] = quality1080;
    data['quality_1440'] = quality1440;
    data['quality_2160'] = quality2160;
    data['quality_4320'] = quality4320;
    return data;
  }
}
