class TypeShow {
  String? id;
  String? typeShow;
  String? typeShowTitle;

  TypeShow({this.id, this.typeShow, this.typeShowTitle});

  TypeShow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeShow = json['typeShow'];
    typeShowTitle = json['typeShowTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['typeShow'] = typeShow;
    data['typeShowTitle'] = typeShowTitle;
    return data;
  }
}
