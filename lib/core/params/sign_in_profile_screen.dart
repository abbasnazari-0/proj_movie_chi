class SignInParams {
  final String email;
  final String password;
  final String phoneNumber;
  final String fullName;
  final String? photoUrl;
  final String? authCode;
  final String? userToken;
  final bool useGoogle;

  SignInParams(this.email, this.password, this.phoneNumber, this.fullName,
      this.photoUrl, this.authCode, this.userToken, this.useGoogle);
}
