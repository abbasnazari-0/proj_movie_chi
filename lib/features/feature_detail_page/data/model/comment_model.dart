class CommentDataModel {
  String? id;
  String? userTag;
  String? vidTag;
  String? comment;
  String? time;
  String? score;

  CommentDataModel(
      {this.id,
      this.userTag,
      this.vidTag,
      this.comment,
      this.time,
      this.score});

  CommentDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userTag = json['user_tag'];
    vidTag = json['vid_tag'];
    comment = json['comment'];
    time = json['time'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_tag'] = userTag;
    data['vid_tag'] = vidTag;
    data['comment'] = comment;
    data['time'] = time;
    data['score'] = score;
    return data;
  }
}
