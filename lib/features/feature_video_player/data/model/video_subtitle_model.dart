class VideoSubtitle {
  List<Data>? data;
  bool? result;
  int? amount;
  String? message;

  VideoSubtitle({this.data, this.result, this.amount, this.message});

  VideoSubtitle.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    result = json['result'];
    amount = json['amount'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['result'] = result;
    data['amount'] = amount;
    data['message'] = message;
    return data;
  }
}

class Data {
  String? id;
  String? title;
  String? year;
  String? subId;
  String? caption;

  Data({this.id, this.title, this.year, this.subId, this.caption});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    year = json['year'];
    subId = json['sub_id'];
    caption = json['caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['year'] = year;
    data['sub_id'] = subId;
    data['caption'] = caption;
    return data;
  }
}
