class ReelsModel {
  String? id;
  String? caption;
  String? tag;
  String? thumbnail;
  String? video;
  String? videoTags;
  String? view;
  String? reelsLike;
  String? userLiked;

  ReelsModel(
      {this.id,
      this.caption,
      this.tag,
      this.thumbnail,
      this.video,
      this.videoTags,
      this.view,
      this.reelsLike,
      this.userLiked});

  ReelsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    caption = json['caption'];
    tag = json['tag'];
    thumbnail = json['thumbnail'];
    video = json['video'];
    videoTags = json['video_tags'];
    view = json['view'];
    reelsLike = json['reels_like'];
    userLiked = json['user_liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['caption'] = caption;
    data['tag'] = tag;
    data['thumbnail'] = thumbnail;
    data['video'] = video;
    data['video_tags'] = videoTags;
    data['view'] = view;
    data['reels_like'] = reelsLike;
    data['user_liked'] = userLiked;
    return data;
  }
}
