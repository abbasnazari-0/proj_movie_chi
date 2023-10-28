import 'package:movie_chi/features/feature_catagory/domain/entities/catagory_entity.dart';

// ignore: must_be_immutable
class CatagoryModel extends CatagoryEntity {
  CatagoryModel({
    String? id,
    String? title,
    String? subject,
    String? desc,
    String? pic,
    String? vid720,
    String? vid480,
    String? vid360,
    String? vid240,
    String? cat,
    String? homeCat,
    String? uniquId,
    String? sections,
    String? iscopy,
  }) : super(
            cat: cat,
            desc: desc,
            homeCat: homeCat,
            id: id,
            iscopy: iscopy,
            pic: pic,
            sections: sections,
            subject: subject,
            title: title,
            uniquId: uniquId,
            vid240: vid240,
            vid360: vid360,
            vid480: vid480,
            vid720: vid720);

  factory CatagoryModel.fromJson(Map<String, dynamic> json) {
    return CatagoryModel(
      id: json['id'],
      title: json['title'],
      subject: json['subject'],
      desc: json['desc'],
      pic: json['pic'],
      vid720: json['vid_720'],
      vid480: json['vid_480'],
      vid360: json['vid_360'],
      vid240: json['vid_240'],
      cat: json['cat'],
      homeCat: json['home_cat'],
      uniquId: json['uniqu_id'],
      sections: json['sections'],
      iscopy: json['iscopy'],
    );
  }
}
