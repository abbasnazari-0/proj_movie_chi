import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_support/presentation/controllers/support_page_controller.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class SupportContent extends StatelessWidget {
  const SupportContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportPageController>(
        id: "message",
        builder: (cont) {
          if (cont.pageStatus == PageStatus.empty) {
            return Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Lottie.asset("assets/lotties/support.json", repeat: false),
                  MyText(
                      txt: 'پیامی برای شما وجود ندارد',
                      color: Colors.white,
                      size: 15.sp,
                      fontWeight: FontWeight.bold),
                ],
              ),
            ));
          }
          if (cont.pageStatus == PageStatus.loading) {
            return Expanded(
                child: Lottie.asset(
              "assets/lotties/loading.json",
              repeat: false,
            ));
          }
          if (cont.pageStatus == PageStatus.error) {
            return Expanded(
                child: Column(
              children: [
                Lottie.asset("assets/lotties/error.json", repeat: false),
                MyText(
                    txt: 'خطایی رخ داده است',
                    color: Colors.white,
                    size: 15.sp,
                    fontWeight: FontWeight.bold),
              ],
            ));
          }

          return Expanded(
            child: SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              controller: cont.refreshController,
              // onRefresh: () async {
              //   cont.refreshController.refreshCompleted();
              //   cont.getMessage();
              // },
              onLoading: () async {
                await cont.getMessage();
                cont.refreshController.loadComplete();
              },
              reverse: true,
              child: ListView.builder(
                // reverse: true,
                itemCount: cont.messageClassModel.data?.length ?? 0,
                padding: const EdgeInsets.symmetric(vertical: 5),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          cont.messageClassModel.data?[index].from ==
                                  "from_user"
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                      children: [
                        if (cont.messageClassModel.data?[index].from ==
                            "from_user")
                          CircleAvatar(
                            radius: 0.03.sh,
                            backgroundImage: const NetworkImage(
                                'https://avatars.githubusercontent.com/u/01503001?v=4'),
                          ),
                        SizedBox(width: 0.02.sw),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                cont.messageClassModel.data?[index].from ==
                                        "from_user"
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                            children: [
                              MyText(
                                txt: cont.messageClassModel.data?[index].from ==
                                        "from_user"
                                    ? "شما"
                                    : "پشتیبانی",
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color
                                    ?.withAlpha(200),
                                size: 8.sp,
                                fontWeight: FontWeight.w300,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.01.sh),
                              SizedBox(
                                width: 0.5.sw,
                                child: MyText(
                                  txt:
                                      cont.messageClassModel.data?[index].msg ??
                                          "",
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                  size: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 0.01.sh),
                              MyText(
                                txt: cont.messageClassModel.data?[index].time ??
                                    "",
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color
                                    ?.withAlpha(200),
                                size: 8.sp,
                                fontWeight: FontWeight.w300,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 0.02.sw),
                        if (cont.messageClassModel.data?[index].from ==
                            "from_admin")
                          CircleAvatar(
                            radius: 0.03.sh,
                            backgroundImage: const NetworkImage(
                                'https://avatars.githubusercontent.com/u/60203108?v=4'),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
