class UserLoginModel {
  String? userTag;
  String? userStatus;
  String? fullName;
  String? timeOutPremium;
  String? downloadMax;

  UserLoginModel({this.userTag, this.userStatus});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    userTag = json['user_tag'];
    userStatus = json['user_status'];
    fullName = json['full_name'];
    timeOutPremium = json['time_out_premium'];
    downloadMax = json['download_max'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_tag'] = userTag;
    data['user_status'] = userStatus;
    data['full_name'] = fullName;
    data['time_out_premium'] = timeOutPremium;
    data['download_max'] = downloadMax;
    return data;
  }
}
