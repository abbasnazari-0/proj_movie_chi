import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/comment_like_model.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/comment_repies_model.dart';
import 'package:movie_chi/features/feature_detail_page/domain/usecases/video_detail_usecase.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/controllers/detail_page_controller.dart';

export 'package:movie_chi/core/utils/page_status.dart';

class CommmentController extends GetxController {
  final VideoDetailUseCase videoDetailUseCase;

  CommmentController(this.videoDetailUseCase);

  PageStatus commentSpoilerCommentStatus = PageStatus.empty;

  reportCommentSpoiler(String commentId) async {
    DataState dataState =
        await videoDetailUseCase.reportCommentSpoiler(commentId);

    if (dataState is DataSuccess) {
      Constants.showGeneralSnackBar(
          "گزارش شد", "با موفقیت ثبت شد\nسپاس از شما");
    } else {
      Constants.showGeneralSnackBar("خطا", dataState.error ?? "");
    }
  }

  likeComment(int commentId, DetailPageController detailPageController) async {
    DataState dataState = await videoDetailUseCase.submitCommentLike(commentId);

    if (dataState is DataSuccess) {
      CommentLikesData commentLikesData = dataState.data;

      for (var e in detailPageController.commentList) {
        if (e.id == commentId.toString()) {
          e.userLiked = commentLikesData.data?.userlikStatus.toString();
          e.userDesLiked = '${commentLikesData.data?.userDesklikStatus ?? "0"}';
          // e.userDesLiked = commentLikesData.data?.userDesklikStatus.toString();
          e.totalLike = commentLikesData.data?.likes.toString();
          e.totalDisLike = commentLikesData.data?.dislikes.toString();
        }
      }
      detailPageController.update();
    } else {}
  }

  unlikeComment(
      int commentId, DetailPageController detailPageController) async {
    DataState dataState =
        await videoDetailUseCase.submitCommentDislike(commentId);

    if (dataState is DataSuccess) {
      CommentLikesData commentLikesData = dataState.data;

      for (var e in detailPageController.commentList) {
        if (e.id == commentId.toString()) {
          e.userLiked = '${commentLikesData.data?.userlikStatus ?? "0"}';
          e.userDesLiked = commentLikesData.data?.userDesklikStatus.toString();
          e.totalDisLike = commentLikesData.data?.dislikes.toString();
          e.totalLike = commentLikesData.data?.likes.toString();
        }
      }
      detailPageController.update();
    } else {}
  }

  List commentReplies = [];
  getCommentReplies(
      int commentID, DetailPageController detailPageController) async {
    DataState dataState = await videoDetailUseCase.getCommentReplies(commentID);

    if (dataState is DataSuccess) {
      CommentReplies commentReplies = dataState.data;

      for (var e in detailPageController.commentList) {
        if (e.id == commentID.toString()) {
          e.replies = commentReplies.data ?? [];
        }
      }

      detailPageController.update();
    } else {
      debugPrint("erorr : ${dataState.error}");
    }
  }

  // submit reply to comment
  addCommentReplies(int commentId, String reply,
      DetailPageController detailPageController) async {
    DataState dataState =
        await videoDetailUseCase.addCommentVideoReplies(commentId, reply);

    if (dataState is DataSuccess) {
      CommentReplies commentReplies = dataState.data;
      for (var e in detailPageController.commentList) {
        if (e.id == commentId.toString()) {
          e.replies = commentReplies.data ?? [];
        }
      }

      detailPageController.update();
    } else {}
  }
}
