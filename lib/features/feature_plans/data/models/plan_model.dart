class PlanModel {
  String? status;
  List<PlanData>? data;
  String? title;
  String? desc;

  PlanModel({this.status, this.data, this.desc, this.title});

  PlanModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    title = json['title'];
    desc = json['desc'];
    if (json['data'] != null) {
      data = <PlanData>[];
      json['data'].forEach((v) {
        data!.add(PlanData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['title'] = title;
    data['desc'] = desc;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanData {
  String? id;
  String? planTitle;
  String? planDownMax;
  String? planTimeDay;
  String? planDesc;
  String? planPrice;
  String? planPriceOff;
  String? planSelected;

  PlanData(
      {this.id,
      this.planTitle,
      this.planDownMax,
      this.planTimeDay,
      this.planDesc,
      this.planPrice,
      this.planPriceOff,
      this.planSelected});

  PlanData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planTitle = json['plan_title'];
    planDownMax = json['plan_down_max'];
    planTimeDay = json['plan_time_day'];
    planDesc = json['plan_desc'];
    planPrice = json['plan_price'];
    planPriceOff = json['plan_price_off'];
    planSelected = json['plan_selected'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['plan_title'] = planTitle;
    data['plan_down_max'] = planDownMax;
    data['plan_time_day'] = planTimeDay;
    data['plan_desc'] = planDesc;
    data['plan_price'] = planPrice;
    data['plan_price_off'] = planPriceOff;
    data['plan_selected'] = planSelected;
    return data;
  }
}
