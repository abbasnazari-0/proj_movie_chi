import '../../../../core/utils/constants.dart';

class MySnackBar {
  MySnackBar(title, message) {
    Constants.showGeneralSnackBar(title, message);
  }
}
