import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_critism/data/data_source/remote/dataSenderCriticsm.dart';

class VideoReporter {
  final String title;
  final String tag;

  final TextEditingController _textEditingController = TextEditingController();

  VideoReporter({required this.title, required this.tag});
  void postCritsimData() {
    if (_textEditingController.text.isEmpty) {
      Constants.showGeneralSnackBar(
          'لطفا متنی را بنویسید', 'لطفا متنی را بنویسید');
      return;
    }
    Constants.showGeneralSnackBar("لطفا صبر کنید", "در حال ارسال اطلاعات");
    DataSenderCritism datasender = DataSenderCritism();

    datasender
        .dataSender(
            "گزارش خطا در فیلم \n اسم فیلم : $title \nتگ فیلم : $tag \n متن گزارش : ${_textEditingController.text}")
        .then((response) {
      if (response.data.startsWith('success')) {
        Constants.showGeneralSnackBar('تشکر از شما ',
            'با تشکر از شما ما در سدد توسعه بهترین اپلیکیشن از شما میابشیم');

        Get.close(0);
      }
    });
  }

  Future<dynamic> videoReportBug(BuildContext context) {
    return Get.bottomSheet(Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Theme.of(context).primaryColor,
          ),
          padding: EdgeInsets.all(10.sp),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.sp),
                MyText(
                  txt: "گزاش خطا",
                  fontWeight: FontWeight.bold,
                  size: 18.sp,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.sp),
                MyText(
                  txt:
                      "با گزاش دادن مشکلات و خطا های فیلم ما را مطلع کنید\n تا از آن با خبر شویم تا این مشکل را بزودی حل کنیم",
                  fontWeight: FontWeight.bold,
                  size: 12.sp,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.sp),
                TextFormField(
                  controller: _textEditingController,
                  scrollPhysics: const BouncingScrollPhysics(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    hintText: "مشکلی که با آن مواجه شدید را بنویسید...",
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: 10.sp),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    // full width
                    minimumSize: Size(double.infinity, 50.sp),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                  onPressed: () {
                    postCritsimData();
                  },
                  child: const MyText(
                    txt: "ارسال",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
