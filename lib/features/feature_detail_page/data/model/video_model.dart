class Video {
  String? id;
  String? title;
  String? imdb;
  String? tag;
  String? desc;
  String? thumbnail1x;
  String? thumbnail2x;
  String? qualitiesId;
  String? galleryId;
  String? quality1080;
  String? quality1440;
  String? quality2160;
  String? quality240;
  String? quality360;
  String? quality4320;
  String? quality480;
  String? quality720;
  String? view;
  String? userLiked;
  String? userBookmarked;
  List<String>? tagData;
  List<ArtistData>? artistData;
  String? lastSessionTime;
  String? type;
  String? commonTag;
  String? subtitle;
  String? dubble;
  String? status;
  String? year;
  String? duration;
  List<TrailerSources>? trailerSources;

  Video({
    this.id,
    this.title,
    this.imdb,
    this.tag,
    this.desc,
    this.thumbnail1x,
    this.thumbnail2x,
    this.qualitiesId,
    this.galleryId,
    this.quality1080,
    this.quality1440,
    this.quality2160,
    this.quality240,
    this.quality360,
    this.quality4320,
    this.quality480,
    this.quality720,
    this.view,
    this.userLiked,
    this.userBookmarked,
    this.tagData,
    this.artistData,
    this.lastSessionTime,
    this.type,
    this.commonTag,
    this.subtitle,
    this.dubble,
    this.status,
    this.year,
    this.duration,
    this.trailerSources,
  });

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imdb = json['imdb'];
    tag = json['tag'];
    desc = json['desc'];
    thumbnail1x = json['thumbnail_1x'];
    thumbnail2x = json['thumbnail_2x'];
    qualitiesId = json['qualities_id'];
    galleryId = json['gallery_id'];
    quality1080 = json['quality_1080'];
    quality1440 = json['quality_1440'];
    quality2160 = json['quality_2160'];
    quality240 = json['quality_240'];
    quality360 = json['quality_360'];
    quality4320 = json['quality_4320'];
    quality480 = json['quality_480'];
    quality720 = json['quality_720'];
    view = json['view'];
    userLiked = json['user_liked'];
    userBookmarked = json['user_bookmarked'];
    if (json['tag_data'] != null) {
      tagData = json['tag_data'].cast<String>();
    }
    if (json['artist_data'] != null) {
      artistData = <ArtistData>[];
      json['artist_data'].forEach((v) {
        artistData!.add(ArtistData.fromJson(v));
      });
    }
    lastSessionTime = json['last_session_time'];
    type = json['type'];
    commonTag = json['common_tag'];
    subtitle = json['subtitle'];
    dubble = json['dubble'];
    status = json['status'];
    year = json['year'];
    if (json['trailer_sources'] != null) {
      trailerSources = <TrailerSources>[];
      json['trailer_sources'].forEach((v) {
        trailerSources!.add(TrailerSources.fromJson(v));
      });
    }
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['imdb'] = imdb;
    data['tag'] = tag;
    data['desc'] = desc;
    data['thumbnail_1x'] = thumbnail1x;
    data['thumbnail_2x'] = thumbnail2x;
    data['qualities_id'] = qualitiesId;
    data['gallery_id'] = galleryId;
    data['quality_1080'] = quality1080;
    data['quality_1440'] = quality1440;
    data['quality_2160'] = quality2160;
    data['quality_240'] = quality240;
    data['quality_360'] = quality360;
    data['quality_4320'] = quality4320;
    data['quality_480'] = quality480;
    data['quality_720'] = quality720;
    data['view'] = view;
    data['user_liked'] = userLiked;
    data['user_bookmarked'] = userBookmarked;
    data['tag_data'] = tagData;
    if (artistData != null) {
      data['artist_data'] = artistData!.map((v) => v.toJson()).toList();
    }
    data['last_session_time'] = lastSessionTime;
    data['type'] = type;
    data['common_tag'] = commonTag;
    data['subtitle'] = subtitle;
    data['dubble'] = dubble;
    data['status'] = status;
    data['year'] = year;
    if (trailerSources != null) {
      data['trailer_sources'] = trailerSources!.map((v) => v.toJson()).toList();
    }
    data['duration'] = duration;

    return data;
  }
}

class ArtistData {
  String? id;
  String? artistName;
  String? artistPic;
  String? artistTag;

  ArtistData({this.id, this.artistName, this.artistPic, this.artistTag});

  ArtistData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    artistName = json['artist_name'];
    artistPic = json['artist_pic'];
    artistTag = json['artist_tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['artist_name'] = artistName;
    data['artist_pic'] = artistPic;
    data['artist_tag'] = artistTag;
    return data;
  }
}

class TrailerSources {
  String? id;
  String? path;
  String? tag;
  String? title;

  TrailerSources({this.id, this.path, this.tag, this.title});

  TrailerSources.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    tag = json['tag'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['path'] = path;
    data['tag'] = tag;
    data['title'] = title;
    return data;
  }
}
