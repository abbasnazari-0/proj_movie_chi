import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/comment_like_model.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/comment_model.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/comment_repies_model.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/general_response_model.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';

import '../../../../core/models/search_video_model.dart';
import '../../../../core/params/notification_subscribe.dart';
import '../../data/model/location_ip_model.dart';
import '../repositories/video_detail_repository.dart';

class VideoDetailUseCase {
  final VideoDetailRepository repository;

  VideoDetailUseCase(this.repository);

  Future<DataState<Video>> getVideoDetail(String tag, String userTag) async {
    return await repository.getVideoDetail(tag, userTag);
  }

  Future<DataState<List>> getVideoGallery(String galleryId) async {
    return await repository.getVideoGallery(galleryId);
  }

  Future<DataState<List<CommentDataModel>>> getVideoComments(
      String videoTags, int page) async {
    return await repository.getVideoComments(videoTags, page);
  }

  Future<DataState<CommentSpoilReport>> reportCommentSpoiler(
      String commentId) async {
    return await repository.reportCommentSpoiler(commentId);
  }

  Future<DataState> addVideoComments(
      String videoTags, String userTag, String comment) async {
    return await repository.addVideoComments(videoTags, userTag, comment);
  }

  Future<DataState<List<SearchVideo>>> getVideoSuggestions(
      String videoTags, String selectvideoTags) async {
    return await repository.getVideoSuggestions(videoTags, selectvideoTags);
  }

  Future<DataState<String>> submitBookmark(
      String videoTags, String userTag, String status) async {
    return await repository.submitBookmark(videoTags, userTag, status);
  }

  Future<DataState<CommentLikesData>> submitCommentLike(int commentID) async {
    return await repository.submitCommentLike(commentID);
  }

  Future<DataState<CommentLikesData>> submitCommentDislike(
      int commentID) async {
    return await repository.submitCommentDislike(commentID);
  }

  Future<DataState<CommentReplies>> getCommentReplies(int commentID) async {
    return await repository.getCommentVideoReplies(commentID);
  }

  Future<DataState<CommentReplies>> addCommentVideoReplies(
      int commentID, String reply) async {
    return await repository.addCommentVideoReplies(commentID, reply);
  }

  Future<DataState<String>> submitLike(
      String videoTags, String userTag, String status) async {
    return await repository.submitLike(videoTags, userTag, status);
  }

  Future<DataState<LocationModel>> getLocationFromIp() async {
    return await repository.getLocationFromIp();
  }

  subscribeNotification(NotificationSubscribeParams params) async {
    return await repository.subscribeNotification(params);
  }
}
