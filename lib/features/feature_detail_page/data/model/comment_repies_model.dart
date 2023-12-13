class CommentReplies {
  String? status;
  String? message;
  List<CommentRepliesDataModel>? data;

  CommentReplies({this.status, this.message, this.data});

  CommentReplies.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CommentRepliesDataModel>[];
      json['data'].forEach((v) {
        data!.add(CommentRepliesDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentRepliesDataModel {
  String? id;
  String? userTag;
  String? commentId;
  String? commontStatus;
  String? replyText;
  String? fullName;

  CommentRepliesDataModel(
      {this.id,
      this.userTag,
      this.commentId,
      this.commontStatus,
      this.replyText,
      this.fullName});

  CommentRepliesDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userTag = json['user_tag'];
    commentId = json['comment_id'];
    commontStatus = json['commont_status'];
    replyText = json['reply_text'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_tag'] = userTag;
    data['comment_id'] = commentId;
    data['commont_status'] = commontStatus;
    data['reply_text'] = replyText;
    data['full_name'] = fullName;
    return data;
  }
}
