class SearchVideo {
  String? id;
  String? title;
  String? imdb;
  String? tag;
  String? desc;
  String? thumbnail1x;
  String? view;
  String? type;
  String? commonTag;
  String? subtitle;
  String? dubble;

  SearchVideo({
    this.id,
    this.title,
    this.imdb,
    this.tag,
    this.desc,
    this.thumbnail1x,
    this.view,
    this.type,
    this.commonTag,
    this.subtitle,
    this.dubble,
  });

  SearchVideo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imdb = json['imdb'];
    tag = json['tag'];
    desc = json['desc'];
    thumbnail1x = json['thumbnail_1x'];
    view = json['view'];
    type = json['type'];
    commonTag = json['common_tag'];
    subtitle = json['subtitle'];
    dubble = json['dubble'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['imdb'] = imdb;
    data['tag'] = tag;
    data['desc'] = desc;
    data['thumbnail_1x'] = thumbnail1x;
    data['view'] = view;
    data['type'] = type;
    data['common_tag'] = commonTag;
    data['subtitle'] = subtitle;
    data['dubble'] = dubble;

    return data;
  }
}
