class UserLoginModel {
  String? userTag;
  String? userStatus;
  String? fullName;
  String? timeOutPremium;
  String? downloadMax;
  String? userAuth;
  String? profile;

  UserLoginModel({this.userTag, this.userStatus, this.userAuth});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    userTag = json['user_tag'];
    userStatus = json['user_status'];
    fullName = json['full_name'];
    timeOutPremium = json['time_out_premium'];
    downloadMax = json['download_max'];
    userAuth = json['user_auth'];
    profile = json['pic'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_tag'] = userTag;
    data['user_status'] = userStatus;
    data['full_name'] = fullName;
    data['time_out_premium'] = timeOutPremium;
    data['download_max'] = downloadMax;
    data['user_auth'] = userAuth;
    data['pic'] = profile;
    return data;
  }
}
