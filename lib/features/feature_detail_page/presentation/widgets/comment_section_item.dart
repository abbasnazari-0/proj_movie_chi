import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/comment_model.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/comment_repies_model.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/controllers/comment_controller.dart';
import 'package:movie_chi/locator.dart';
import 'dart:ui' as ui;

import '../../../../core/widgets/mytext.dart';
import '../controllers/detail_page_controller.dart';

class CommenItem extends StatefulWidget {
  const CommenItem({
    super.key,
    required this.width,
    required this.pageController,
    required this.index,
  });

  final double width;
  final DetailPageController pageController;
  final int index;

  @override
  State<CommenItem> createState() => _CommenItemState();
}

class _CommenItemState extends State<CommenItem> {
  bool repiledEnable = false;
  TextEditingController commentReplyController = TextEditingController();

  Widget backdropFilterExample(BuildContext context, Widget child) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        child,
        BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 8.0,
            sigmaY: 8.0,
          ),
          child: Container(
            color: Colors.transparent,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        children: [
          const Gap(10),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Container(
                    width: 40,
                    height: 40,
                    color: Theme.of(context).primaryColor,
                    child: const Center(
                        child: Icon(Iconsax.user,
                            color: Color.fromRGBO(255, 255, 255, 1)))),
              ),
              const SizedBox(width: 10),
              MyText(
                txt: widget.pageController.commentList[widget.index].userTag!,
              ),
              const Spacer(),
              MyText(
                txt: timeAgo(
                    widget.pageController.commentList[widget.index].time!),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(
                alignment: Alignment.centerRight,
                child: widget.pageController.commentList[widget.index]
                            .spoileStatus ==
                        SpoileStatus.spoiled
                    ? Stack(
                        children: [
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                            child: MyText(
                              txt: widget.pageController
                                  .commentList[widget.index].comment!,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.remove_red_eye_rounded),
                                    MyText(
                                      txt: "دارای متن اسپویل شده",
                                    )
                                  ],
                                ),
                                OutlinedButton(
                                    onPressed: () {
                                      widget
                                              .pageController
                                              .commentList[widget.index]
                                              .spoileStatus =
                                          SpoileStatus.notSpoiled;
                                      widget.pageController.update();
                                    },
                                    child: const MyText(
                                        txt: "دیدن متن اسپویل شده"))
                              ],
                            ),
                          )
                        ],
                      )
                    : MyText(
                        txt: widget
                            .pageController.commentList[widget.index].comment!,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.right,
                      )),
          ),
          const Gap(10),
          GetBuilder<CommmentController>(
              init: CommmentController(locator()),
              builder: (controller) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TextButton.icon(
                        label: MyText(
                            txt: widget.pageController.commentList[widget.index]
                                .totalLike
                                .toString()),
                        onPressed: () {
                          controller.likeComment(
                              int.parse(widget.pageController
                                      .commentList[widget.index].id ??
                                  "0"),
                              widget.pageController);
                        },
                        icon: FaIcon(
                          int.parse(widget
                                          .pageController
                                          .commentList[widget.index]
                                          .userLiked ??
                                      "0") >
                                  0
                              ? FontAwesomeIcons.solidThumbsUp
                              : FontAwesomeIcons.thumbsUp,
                        ),
                      ),

                      TextButton.icon(
                        label: MyText(
                            txt: widget.pageController.commentList[widget.index]
                                .totalDisLike
                                .toString()),
                        onPressed: () {
                          controller.unlikeComment(
                              int.parse(widget.pageController
                                      .commentList[widget.index].id ??
                                  "0"),
                              widget.pageController);
                        },
                        icon: FaIcon(
                          int.parse(widget
                                          .pageController
                                          .commentList[widget.index]
                                          .userDesLiked ??
                                      "0") >
                                  0
                              ? FontAwesomeIcons.solidThumbsDown
                              : FontAwesomeIcons.thumbsDown,
                        ),
                      ),

                      // like

                      TextButton.icon(
                          onPressed: () {
                            repiledEnable = !repiledEnable;
                            setState(() {});

                            controller.getCommentReplies(
                                int.parse(widget.pageController
                                        .commentList[widget.index].id ??
                                    "0"),
                                widget.pageController);
                          },
                          icon: const Icon(
                            Iconsax.message,
                          ),
                          label: MyText(
                              txt:
                                  "پاسخ (${widget.pageController.commentList[widget.index].totalReply ?? ""})",
                              color: Theme.of(context).colorScheme.secondary)),
                      // const Spacer(),
                      // spoil report
                      TextButton.icon(
                        onPressed: () {
                          controller.reportCommentSpoiler(widget.pageController
                                  .commentList[widget.index].id ??
                              "");
                        },
                        icon: const Icon(
                          Icons.report_rounded,
                        ),
                        label: const MyText(txt: 'گزارش اسپویل'),
                      )

                      // dislike

                      // label: MyText(
                      //     txt: "لایک",
                      //     color: Theme.of(context).colorScheme.secondary)),

                      // reply
                    ],
                  ),
                );
              }),
          const Gap(10),

          if (repiledEnable &&
              widget.pageController.commentList[widget.index].replies != null)
            if (widget
                .pageController.commentList[widget.index].replies!.isNotEmpty)
              for (CommentRepliesDataModel e
                  in widget.pageController.commentList[widget.index].replies ??
                      [])
                ListTile(
                  contentPadding: const EdgeInsets.only(right: 30),
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Icon(Iconsax.user,
                          color: e.userTag!.startsWith("admin")
                              ? Colors.amber
                              : const Color.fromRGBO(255, 255, 255, 1)),
                    ),
                  ),
                  title: MyText(
                      txt: e.fullName ?? "کاربر بی نام",
                      size: 14,
                      color: e.userTag!.startsWith("admin")
                          ? Colors.amber
                          : Colors.grey),
                  subtitle: MyText(
                    txt: e.replyText ?? "",
                    size: 18,
                  ),
                ),

          // ReplyItem(

          // )
          if (repiledEnable)
            GetBuilder<CommmentController>(builder: (controller) {
              return ListTile(
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                leading: const Icon(Icons.subdirectory_arrow_left_rounded),
                contentPadding: const EdgeInsets.only(right: 30),
                title: TextField(
                  controller: commentReplyController,
                  decoration: const InputDecoration(
                    hintText: 'پاسخ به ...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  onSubmitted: (value) {
                    controller.addCommentReplies(
                        int.parse(widget
                                .pageController.commentList[widget.index].id ??
                            "0"),
                        value,
                        widget.pageController);
                    commentReplyController.text = "";
                  },
                ),
                trailing: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      controller.addCommentReplies(
                          int.parse(widget.pageController
                                  .commentList[widget.index].id ??
                              "0"),
                          commentReplyController.text,
                          widget.pageController);
                      commentReplyController.text = "";
                    }),
              );
            })
        ],
      ),
    );
  }

  // function that convert time to previuos time in persian
  String timeAgo(time) {
    DateTime tim = DateTime.parse(time);

    // convert time to tehra time

    DateTime now = DateTime.now();

    Duration diff = now.difference(tim);

    if (diff < const Duration(minutes: 1)) {
      return 'همین الان';
    } else if (diff < const Duration(hours: 1)) {
      int minutes = diff.inMinutes;
      return '$minutes دقیقه پیش';
    } else if (diff < const Duration(days: 1)) {
      int hours = diff.inHours;
      return '$hours ساعت پیش';
    } else {
      int days = diff.inDays;
      return '$days روز پیش';
    }
  }
}
