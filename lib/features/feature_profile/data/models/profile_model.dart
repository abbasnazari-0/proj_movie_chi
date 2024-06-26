class ProfileModel {
  String? status;
  String? message;
  List<ProfileModelData>? data;

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProfileModelData>[];
      json['data'].forEach((v) {
        data!.add(ProfileModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileModelData {
  String? fullName;
  String? userAuth;
  String? lastName;
  String? pic;
  String? signInMethod;

  ProfileModelData(
      {this.fullName,
      this.userAuth,
      this.lastName,
      this.pic,
      this.signInMethod});

  ProfileModelData.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    userAuth = json['user_auth'];
    lastName = json['last_name'];
    pic = json['pic'];
    signInMethod = json['sign_in_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['user_auth'] = userAuth;
    data['last_name'] = lastName;
    data['pic'] = pic;
    data['sign_in_method'] = signInMethod;
    return data;
  }
}
