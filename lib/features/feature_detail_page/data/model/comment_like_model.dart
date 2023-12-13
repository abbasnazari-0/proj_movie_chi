class CommentLikesData {
  String? status;
  String? message;
  CommendDataLiker? data;

  CommentLikesData({this.status, this.message, this.data});

  CommentLikesData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? CommendDataLiker.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CommendDataLiker {
  String? likes;
  String? dislikes;
  int? userDesklikStatus;
  int? userlikStatus;
  String? commentID;

  CommendDataLiker(
      {this.likes, this.dislikes, this.userDesklikStatus, this.commentID});

  CommendDataLiker.fromJson(Map<String, dynamic> json) {
    likes = json['likes'];
    dislikes = json['dislikes'];
    userDesklikStatus = json['user_desklik_status'];
    userlikStatus = json['user_like_status'];
    commentID = json['comment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['likes'] = likes;
    data['dislikes'] = dislikes;
    data['user_desklik_status'] = userDesklikStatus;
    data['user_like_status'] = userlikStatus;
    data['comment_id'] = commentID;
    return data;
  }
}
