import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_chi/core/params/sign_in_profile_screen.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_sign_in_profile.dart';

class GoogleLoginController extends GetxController {
  /// The scopes required by this application.
  static const List<String> scopes = <String>[
    'email',
  ];
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  login() async {
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      Get.off(() => SignInProfileScreen(),
          arguments: SignInParams(
              googleSignInAccount.email,
              "",
              "",
              googleSignInAccount.displayName ?? "",
              googleSignInAccount.photoUrl,
              googleSignInAccount.serverAuthCode,
              googleSignInAccount.id,
              true));
    } else {
      Constants.showGeneralSnackBar("خطا", "خطا در ورود با گوگل");
    }
  }

  @override
  void onReady() {
    super.onReady();
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;
      // However, in the web...
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      if (isAuthorized) {
        // unawaited(_handleGetContact(account!));
      }
    });

    // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
    //
    // It is recommended by Google Identity Services to render both the One Tap UX
    // and the Google Sign In button together to "reduce friction and improve
    // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
    _googleSignIn.signInSilently();
  }
}
