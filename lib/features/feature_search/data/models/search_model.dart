import 'package:movie_chi/core/models/search_video_model.dart';

class SearchModel {
  List<SearchVideo>? data;
  String? status;
  String? message;
  int? count;
  bool? isBouncerRequested;

  SearchModel(
      {this.data,
      this.status,
      this.message,
      this.count,
      this.isBouncerRequested});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SearchVideo>[];
      json['data'].forEach((v) {
        data!.add(SearchVideo.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
    count = json['count'];
    isBouncerRequested = json['isBouncerRequested'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['message'] = message;
    data['count'] = count;
    data['isBouncerRequested'] = isBouncerRequested;
    return data;
  }
}
