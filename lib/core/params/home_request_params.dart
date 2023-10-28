class HomeRequestParams {
  // http://127.0.0.1/v4/cinimo/home.php?user_tag=4dvcgbfdb&version=434&amount=100&page=0
  final String userTag;
  final String version;
  final String amount;
  final String page;

  HomeRequestParams({
    required this.userTag,
    required this.version,
    required this.amount,
    required this.page,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_tag': userTag,
      'version': version,
      'amount': amount,
      'page': page,
    };
  }
}
