import 'package:movie_chi/features/feature_login_screen/data/models/user_login_model.dart';

class RequestDeviceModel {
  String? status;
  String? message;
  DeviceData? data;

  RequestDeviceModel({this.status, this.message, this.data});

  RequestDeviceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DeviceData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DeviceData {
  String? token;
  String? tokenId;
  String? dateExpired;
  String? status;
  UserLoginModel? userLoginModel;

  DeviceData(
      {this.token,
      this.tokenId,
      this.dateExpired,
      this.status,
      this.userLoginModel});

  DeviceData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    tokenId = json['token_id'];
    dateExpired = json['date_expired'];
    status = json['status'];
    userLoginModel = json['user_data'] != null
        ? UserLoginModel.fromJson(json['user_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['token_id'] = tokenId;
    data['date_expired'] = dateExpired;
    data['status'] = status;
    if (userLoginModel != null) {
      data['user_data'] = userLoginModel!.toJson();
    }
    return data;
  }
}
