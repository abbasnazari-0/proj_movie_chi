class MessageClassModel {
  String? status;
  String? message;
  List<MessageItem>? data;

  MessageClassModel({this.status, this.message, this.data});

  MessageClassModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MessageItem>[];
      json['data'].forEach((v) {
        data!.add(MessageItem.fromJson(v));
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

class MessageItem {
  String? id;
  String? userToken;
  String? msg;
  String? from;
  String? time;
  MessageItem({this.id, this.userToken, this.msg, this.from, this.time});

  MessageItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userToken = json['user_token'];
    msg = json['msg'];
    from = json['from'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_token'] = userToken;
    data['msg'] = msg;
    data['from'] = from;
    data['time'] = time;
    return data;
  }
}
