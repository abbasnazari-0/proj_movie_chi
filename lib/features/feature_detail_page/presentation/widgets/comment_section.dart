import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../controllers/detail_page_controller.dart';
import 'comment_section_item.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({
    super.key,
    required this.pageController,
    required this.width,
  });

  final DetailPageController pageController;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Colors.white10,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: pageController.commentList.length,
              itemBuilder: (context, index) {
                return CommenItem(
                  width: width,
                  pageController: pageController,
                  index: index,
                );
              },
            ),
            const Gap(10),
            const Divider(
              height: 1,
              color: Colors.white10,
            ),
            const Gap(10),
            (pageController.loadingCommentMore == false)
                ? OutlinedButton(
                    onPressed: () {
                      pageController.loadMoreComment();
                    },
                    child: const Text("نظرات بیشتر"),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
