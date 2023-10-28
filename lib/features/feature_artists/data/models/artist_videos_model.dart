import 'package:movie_chi/core/models/search_video_model.dart';

class ArtistVideoData {
  List<SearchVideo>? result;
  String? status;

  ArtistVideoData({this.result, this.status});

  ArtistVideoData.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <SearchVideo>[];
      json['result'].forEach((v) {
        result!.add(SearchVideo.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}
