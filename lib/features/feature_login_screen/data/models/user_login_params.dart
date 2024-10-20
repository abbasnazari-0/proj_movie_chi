import 'package:share_plus/share_plus.dart';

class UserLoginParams {
  final String fullName;
  final String userAuth;
  final String googleId;
  final String googleToken;
  final String signInMethod;
  final String userTag;
  final XFile? profile;

  UserLoginParams(this.fullName, this.userAuth, this.googleId, this.googleToken,
      this.signInMethod, this.userTag,
      {this.profile});
}
