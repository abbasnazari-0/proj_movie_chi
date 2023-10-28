import '../../../feature_detail_page/data/model/video_model.dart';

class PlayListModel {
  String? status;
  String? code;
  String? message;
  List<Video>? data;

  PlayListModel({this.status, this.code, this.message, this.data});

  PlayListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Video>[];
      json['data'].forEach((v) {
        data!.add(Video.fromJson(v));
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
