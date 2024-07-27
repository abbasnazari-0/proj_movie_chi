class HomeCatagory {
  String? status;
  String? code;
  String? message;
  HomeCatagoryData? data;

  HomeCatagory({this.status, this.code, this.message, this.data});

  HomeCatagory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    data =
        json['data'] != null ? HomeCatagoryData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Setting {
  String? androidVersion;
  String? updateTitle;
  String? updateDesc;
  String? updateUrl;

  Setting(
      {this.androidVersion, this.updateTitle, this.updateDesc, this.updateUrl});
  Setting.fromJson(Map<String, dynamic> json) {
    androidVersion = json['android_version'];
    updateTitle = json['update_title'];
    updateDesc = json['update_desc'];
    updateUrl = json['update_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['android_version'] = androidVersion;
    data['update_title'] = updateTitle;
    data['update_desc'] = updateDesc;
    data['update_url'] = updateUrl;
    return data;
  }
}

class HomeCatagoryData {
  String? page;
  // String? amount;
  List<HomeCatagoryItemModel>? data;
  Setting? setting;

  HomeCatagoryData({this.page, this.data, this.setting});

  HomeCatagoryData.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    // amount = json['amount'];
    if (json['data'] != null) {
      data = <HomeCatagoryItemModel>[];
      json['data'].forEach((v) {
        data!.add(HomeCatagoryItemModel.fromJson(v));
      });
    }
    setting =
        json['setting'] != null ? Setting.fromJson(json['setting']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    // data['amount'] = amount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (setting != null) {
      data['setting'] = setting!.toJson();
    }
    return data;
  }
}

class HomeCatagoryItemModel {
  String? id;
  String? title;
  String? values;
  String? valueType;
  String? viewWidth;
  String? viewHeight;
  String? viewColor;
  String? viewName;
  String? colorAlpha;
  List<HomeItemData>? data;

  HomeCatagoryItemModel(
      {this.id,
      this.title,
      this.values,
      this.valueType,
      this.viewWidth,
      this.viewHeight,
      this.viewColor,
      this.viewName,
      this.colorAlpha,
      this.data});

  HomeCatagoryItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    values = json['values'];
    valueType = json['value_type'];
    viewWidth = json['view_width'];
    viewHeight = json['view_height'];
    viewColor = json['view_color'];
    colorAlpha = json['color_alpha'];
    viewName = json['view_name'];
    if (json['data'] != null) {
      data = <HomeItemData>[];
      json['data'].forEach((v) {
        data!.add(HomeItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['values'] = values;
    data['value_type'] = valueType;
    data['view_width'] = viewWidth;
    data['view_height'] = viewHeight;
    data['view_color'] = viewColor;
    data['color_alpha'] = colorAlpha;
    data['view_name'] = viewName;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HomeItemData {
  String? id;
  String? title;
  String? imdb;
  String? tag;
  String? desc;
  String? artistTags;
  String? thumbnail1x;
  String? thumbnail2x;
  String? qualitiesId;
  String? galleryId;
  String? videoTags;
  String? imdbs;
  String? tags;
  String? thumbnail3x;
  String? type;
  String? commonTag;
  String? subtitle;
  String? dubble;

  HomeItemData({
    this.id,
    this.title,
    this.imdb,
    this.tag,
    this.desc,
    this.artistTags,
    this.thumbnail1x,
    this.thumbnail2x,
    this.qualitiesId,
    this.galleryId,
    this.videoTags,
    this.imdbs,
    this.tags,
    this.thumbnail3x,
    this.type,
    this.commonTag,
    this.subtitle,
    this.dubble,
  });

  HomeItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imdb = json['imdb'];
    tag = json['tag'];
    desc = json['desc'];
    artistTags = json['artist_tags'];
    thumbnail1x = json['thumbnail_1x'];
    thumbnail2x = json['thumbnail_2x'];
    qualitiesId = json['qualities_id'];
    galleryId = json['gallery_id'];
    videoTags = json['video_tags'];
    imdbs = json['imdbs'];
    tags = json['tags'];
    thumbnail3x = json['thumbnail_3x'];
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
    data['artist_tags'] = artistTags;
    data['thumbnail_1x'] = thumbnail1x;
    data['thumbnail_2x'] = thumbnail2x;
    data['qualities_id'] = qualitiesId;
    data['gallery_id'] = galleryId;
    data['video_tags'] = videoTags;
    data['imdbs'] = imdbs;
    data['tags'] = tags;
    data['thumbnail_3x'] = thumbnail3x;
    data['type'] = type;
    data['common_tag'] = commonTag;
    data['subtitle'] = subtitle;
    data['dubble'] = dubble;
    return data;
  }
}
