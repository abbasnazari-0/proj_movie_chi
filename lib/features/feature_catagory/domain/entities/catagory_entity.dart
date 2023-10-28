import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class CatagoryEntity extends Equatable {
  String? id;
  String? title;
  String? subject;
  String? desc;
  String? pic;
  String? vid720;
  String? vid480;
  String? vid360;
  String? vid240;
  String? cat;
  String? homeCat;
  String? uniquId;
  String? sections;
  String? iscopy;

  CatagoryEntity(
      {this.id,
      this.title,
      this.subject,
      this.desc,
      this.pic,
      this.vid720,
      this.vid480,
      this.vid360,
      this.vid240,
      this.cat,
      this.homeCat,
      this.uniquId,
      this.sections,
      this.iscopy});
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
