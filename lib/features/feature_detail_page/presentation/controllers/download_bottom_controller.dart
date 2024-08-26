import 'package:get/get.dart';
import 'package:movie_chi/core/utils/page_status.dart';

class DownloadBottomController extends GetxController {
  PageStatus pageStatus = PageStatus.empty;

  updatePageStatus(PageStatus status) {
    pageStatus = status;
    update();
  }
}
