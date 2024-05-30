import 'package:get/get_state_manager/get_state_manager.dart';

class HomeSearchBarController extends GetxController {
  bool advancedFilter = false;

  // year
  String yearSelected = 0.toString();
  // list year from 2023 to 1960
  List<String> yearItems =
      List<String>.generate(2024 - 1960, (index) => (2023 - index).toString());

  /// imdb
  String imdbSelected = "";
  // list imdb from 9.9 to 1.0
  List<String> imdbItems =
      List<String>.generate(9, (index) => "${9 - index}.0");

  // zhanner
  String zhannerSelected = "";
  // list zhanner
  List<String> zhannerList = [
    'اکشن',
    'مرموز',
    'کمدی',
    'ترسناک',
    'ماجراجویی',
    'درام',
    'عاشقانه',
    'رمانتیک',
    'علمی تخیلی',
    'مستند',
    'موزیکال',
    'وسترن',
    'ماهیتی',
    'انیمیشن',
    'هیجان‌انگیز',
    'فانتزی',
    'خانواده',
    'تاریخی',
    'جنایی',
    'معمایی',
    'خشن',
    'ورزشی',
    'کره ایی',
    'جنگی',
    'رازآلود',
    'مذهبی'
  ];

  // type
  String typeSelected = "";
  // list type
  List<String> typeList = ['فیلم', 'سریال'];

  void changeAdvancedFilter(bool value) {
    advancedFilter = value;

    if (value == false) {
      yearSelected = 0.toString();
      imdbSelected = "";
      zhannerSelected = "";
      typeSelected = "";
    }
    update();
  }
}
