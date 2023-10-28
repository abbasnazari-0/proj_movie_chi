import 'home_catagory_model.dart';

class GridModel {
  String? status;
  String? code;
  String? message;
  List<HomeItemData>? data;

  GridModel({this.status, this.code, this.message, this.data});

  GridModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HomeItemData>[];
      json['data'].forEach((v) {
        data!.add(HomeItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
