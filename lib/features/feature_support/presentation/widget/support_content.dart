import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
                  const MyText(
                      txt: 'پیامی برای شما وجود ندارد',
                      color: Colors.white,
                      size: 15,
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
                const MyText(
                    txt: 'خطایی رخ داده است',
                    color: Colors.white,
                    size: 15,
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
                          const CircleAvatar(
                            radius: 0.03,
                            backgroundImage: NetworkImage(
                                'https://avatars.githubusercontent.com/u/01503001?v=4'),
                          ),
                        const SizedBox(width: 0.02),
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
                                size: 8,
                                fontWeight: FontWeight.w300,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Gap(10),
                              SizedBox(
                                width: 0.5,
                                child: MyText(
                                  txt:
                                      cont.messageClassModel.data?[index].msg ??
                                          "",
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                  size: 10,
                                  fontWeight: FontWeight.bold,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Gap(4),
                              MyText(
                                txt: cont.messageClassModel.data?[index].time ??
                                    "",
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color
                                    ?.withAlpha(200),
                                size: 8,
                                fontWeight: FontWeight.w300,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Gap(4),
                        if (cont.messageClassModel.data?[index].from ==
                            "from_admin")
                          const CircleAvatar(
                            radius: 0.33,
                            backgroundImage: NetworkImage(
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
