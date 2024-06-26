import 'package:share_plus/share_plus.dart';

class ProfileUpdator {
  final String firstName;
  final String lastName;
  final String userAuth;
  final XFile? image;
  final String userToken;

  ProfileUpdator({
    required this.firstName,
    required this.lastName,
    required this.userAuth,
    required this.image,
    required this.userToken,
  });
}
