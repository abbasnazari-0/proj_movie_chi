class ArtistModels {
  List<ArtistItemData>? result;
  String? status;

  ArtistModels({this.result, this.status});

  ArtistModels.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <ArtistItemData>[];
      json['result'].forEach((v) {
        result!.add(ArtistItemData.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class ArtistItemData {
  String? artistName;
  String? artistPic;
  String? artistTag;

  ArtistItemData({this.artistName, this.artistPic, this.artistTag});

  ArtistItemData.fromJson(Map<String, dynamic> json) {
    artistName = json['artist_name'];
    artistPic = json['artist_pic'];
    artistTag = json['artist_tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['artist_name'] = artistName;
    data['artist_pic'] = artistPic;
    data['artist_tag'] = artistTag;
    return data;
  }
}
