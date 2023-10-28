class ReelsCommentModel {
  String? id;
  String? vidTag;
  String? userTag;
  String? comment;

  ReelsCommentModel({this.id, this.vidTag, this.userTag, this.comment});

  ReelsCommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vidTag = json['vid_tag'];
    userTag = json['user_tag'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vid_tag'] = vidTag;
    data['user_tag'] = userTag;
    data['comment'] = comment;
    return data;
  }
}
