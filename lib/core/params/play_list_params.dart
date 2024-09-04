import 'dart:convert';

import 'package:movie_chi/core/utils/constants.dart';

class PlayListParams {
  String version;
  String playListId;
  String playListType;
  String keyWord;
  String videoIds;
  VideoTypeType vtype;

  int amount;
  PlayListParams({
    required this.version,
    required this.playListId,
    required this.playListType,
    this.amount = 20,
    this.keyWord = "",
    this.videoIds = "",
    this.vtype = VideoTypeType.both,
  });

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'playlist_id': playListId,
      'playlist_type': playListType,
      'amount': amount,
      'keyWord': keyWord,
      'video_ids': videoIds,
    };
  }

  getVideoTypeAsString() {
    switch (vtype) {
      case VideoTypeType.both:
        return "both";
      case VideoTypeType.movie:
        return "movie";
      case VideoTypeType.serial:
        return "series";
      default:
        return "both";
    }
  }

  factory PlayListParams.fromMap(Map<String, dynamic> map) {
    return PlayListParams(
      version: map['version'],
      playListId: map['playlist_id'],
      playListType: map['playlist_type'],
      amount: map['amount'],
      keyWord: map['keyWord'],
      videoIds: map['video_ids'],
    );
  }
  // tojson
  String toJson() => json.encode(toMap());
}
