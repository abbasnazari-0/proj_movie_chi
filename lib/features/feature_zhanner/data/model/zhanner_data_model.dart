class Zhanner {
  String? id;
  String? tag;
  String? pics;

  Zhanner({this.id, this.tag, this.pics});

  Zhanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    pics = json['pics'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tag'] = tag;
    data['pics'] = pics;
    return data;
  }
}
