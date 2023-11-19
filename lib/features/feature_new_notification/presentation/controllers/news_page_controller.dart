import 'package:get/get.dart';
import 'package:movie_chi/core/utils/database_helper.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/home_page_controller.dart';
import 'package:movie_chi/features/feature_new_notification/domain/usecases/news_use_case.dart';
import 'package:movie_chi/locator.dart';

class NewsPageController extends GetxController {
  NewsUseCase supportUseCase;
  NewsPageController({required this.supportUseCase});

  PageStatus pageStatus = PageStatus.loading;

  List list = [];

  @override
  void onReady() {
    super.onReady();

    refreshAgain();
  }

  refreshAgain() async {
    pageStatus = PageStatus.loading;
    update();
    DictionaryDataBaseHelper dbHelper = locator();
    list = await dbHelper.getQuery('tbl_news_notif');

    print(list);
    pageStatus = PageStatus.success;
    update();
  }

  readNotif(tag) async {
    DictionaryDataBaseHelper dbHelper = locator();
    await dbHelper.updateQuery(
        "UPDATE  tbl_news_notif SET `readed` = 1 WHERE `tag` = '$tag'");

    final homeController = Get.find<HomePageController>();
    homeController.getNotificationNewsNew();
  }
}
