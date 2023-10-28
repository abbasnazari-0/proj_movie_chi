class LocationModel {
  String? ip;
  String? hostname;
  String? city;
  String? region;
  String? country;
  String? loc;
  String? org;
  String? postal;
  String? timezone;
  String? readme;

  LocationModel(
      {this.ip,
      this.hostname,
      this.city,
      this.region,
      this.country,
      this.loc,
      this.org,
      this.postal,
      this.timezone,
      this.readme});

  LocationModel.fromJson(Map<String, dynamic> json) {
    ip = json['ip'];
    hostname = json['hostname'];
    city = json['city'];
    region = json['region'];
    country = json['country'];
    loc = json['loc'];
    org = json['org'];
    postal = json['postal'];
    timezone = json['timezone'];
    readme = json['readme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ip'] = ip;
    data['hostname'] = hostname;
    data['city'] = city;
    data['region'] = region;
    data['country'] = country;
    data['loc'] = loc;
    data['org'] = org;
    data['postal'] = postal;
    data['timezone'] = timezone;
    data['readme'] = readme;
    return data;
  }
}
