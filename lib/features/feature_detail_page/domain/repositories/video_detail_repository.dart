import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/comment_like_model.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/comment_repies_model.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/general_response_model.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';

import '../../../../core/models/search_video_model.dart';
import '../../../../core/params/notification_subscribe.dart';
import '../../data/data_source/remote/getSection_data.dart';
import '../../data/model/comment_model.dart';
import '../../data/model/location_ip_model.dart';

abstract class VideoDetailRepository {
  final VideoDetailDataGetter videoDetailDataGetter;

  VideoDetailRepository(this.videoDetailDataGetter);

  Future<DataState<Video>> getVideoDetail(String videoTag, String userTag);
  // get video gallery
  Future<DataState<List>> getVideoGallery(String galleryId);

  // get video comment
  Future<DataState<List<CommentDataModel>>> getVideoComments(
      String videoTags, int page);

  // report comment spoiler
  Future<DataState<CommentSpoilReport>> reportCommentSpoiler(String commentId);

  // add video comment
  Future<DataState> addVideoComments(
      String videoTags, String userTag, String comment);

  // submit like
  Future<DataState<CommentLikesData>> submitCommentLike(int commentID);

  // submit dislike
  Future<DataState<CommentLikesData>> submitCommentDislike(int commentID);

  // get video replies
  Future<DataState<CommentReplies>> getCommentVideoReplies(int commentID);

  // add video reply
  Future<DataState<CommentReplies>> addCommentVideoReplies(
      int commentID, String reply);

  // get video suggestions
  Future<DataState<List<SearchVideo>>> getVideoSuggestions(
      String videoTags, String selectvideoTags);

  // submit bookmark
  Future<DataState<String>> submitBookmark(
      String videoTags, String userTag, String status);

  // submit like
  Future<DataState<String>> submitLike(
      String videoTags, String userTag, String status);

  // get location from ip
  Future<DataState<LocationModel>> getLocationFromIp();

  // subcribe notification
  Future<DataState<String>> subscribeNotification(
      NotificationSubscribeParams params);
}
