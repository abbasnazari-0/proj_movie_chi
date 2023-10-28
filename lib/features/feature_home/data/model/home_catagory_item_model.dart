import 'package:movie_chi/core/models/search_video_model.dart';

class HomeCatagagoryItemModel {
  String? title;
  List<SearchVideo>? data;

  HomeCatagagoryItemModel({this.title, this.data});

  HomeCatagagoryItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['data'] != null) {
      data = <SearchVideo>[];
      json['data'].forEach((v) {
        data!.add(SearchVideo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
