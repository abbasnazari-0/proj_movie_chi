import 'package:movie_chi/features/feature_detail_page/data/model/comment_repies_model.dart';

enum SpoileStatus { spoiled, notSpoiled }

class CommentDataModel {
  String? id;
  String? userTag;
  String? vidTag;
  String? comment;
  String? time;
  String? score;
  String? totalLike;
  String? totalDisLike;
  String? totalReply;
  String? userLiked;
  String? userDesLiked;
  SpoileStatus? spoileStatus;

  List<CommentRepliesDataModel>? replies;
  CommentDataModel(
      {this.id,
      this.userTag,
      this.vidTag,
      this.comment,
      this.time,
      this.score,
      this.totalLike,
      this.totalDisLike,
      this.userLiked,
      this.userDesLiked,
      this.replies,
      this.spoileStatus});

  CommentDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userTag = json['user_tag'];
    vidTag = json['vid_tag'];
    comment = json['comment'];
    time = json['time'];
    score = json['score'];
    totalLike = json['total_likes'];
    totalDisLike = json['total_un_likes'];
    totalReply = json['total_replied'];
    userLiked = json['user_liked'];
    userDesLiked = json['user_desliked'];
    spoileStatus = json['spoil_status'] == "spoiled"
        ? SpoileStatus.spoiled
        : SpoileStatus.notSpoiled;
    if (json['replies'] != null) {
      replies = <CommentRepliesDataModel>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_tag'] = userTag;
    data['vid_tag'] = vidTag;
    data['comment'] = comment;
    data['time'] = time;
    data['score'] = score;
    data['total_likes'] = totalLike;
    data['total_un_likes'] = totalDisLike;
    data['total_replied'] = totalReply;
    data['user_liked'] = userLiked;
    data['user_desliked'] = userDesLiked;
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    data['spoil_status'] = spoileStatus == SpoileStatus.spoiled
        ? "spoil_status"
        : "not_spoil_status";
    return data;
  }
}
