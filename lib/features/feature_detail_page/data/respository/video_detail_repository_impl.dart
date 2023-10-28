import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_chi/core/params/notification_subscribe.dart';
import 'package:movie_chi/core/utils/json_checker.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/comment_model.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_detail_page/domain/repositories/video_detail_repository.dart';
import 'package:movie_chi/core/models/search_video_model.dart';

import '../model/location_ip_model.dart';

class VideoDetailRepositoryImpl extends VideoDetailRepository {
  VideoDetailRepositoryImpl(super.videoDetailDataGetter);

  @override
  Future<DataState<Video>> getVideoDetail(
      String videoTag, String userTag) async {
    Response res = await videoDetailDataGetter.getData(videoTag, userTag);
    if (res.statusCode == 200) {
      // check if json or not
      if (isJson(res.data)) {
        return DataSuccess(Video.fromJson(jsonDecode(res.data)));
      } else {
        return DataFailed(res.data);
      }
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<List>> getVideoGallery(String galleryId) async {
    Response res = await videoDetailDataGetter.getVideoGallery(galleryId);

    if (res.statusCode == 200) {
      // check if json or not
      if (isJson(res.data)) {
        List galleryList = json.decode(res.data);

        return DataSuccess(galleryList);
      } else {
        return DataFailed(res.data);
      }
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<List<CommentDataModel>>> getVideoComments(
      String videoTags) async {
    Response res = await videoDetailDataGetter.getVideoComments(videoTags);

    if (res.statusCode == 200) {
      // check if json or not
      if (isJson(res.data)) {
        List commentList = json.decode(res.data);

        return DataSuccess(
            commentList.map((e) => CommentDataModel.fromJson(e)).toList());
      } else {
        return DataFailed(res.data);
      }
    } else {
      return DataFailed("Error on Internet Connection");
    }
  }

  @override
  Future<DataState> addVideoComments(
      String videoTags, String userTag, String comment) async {
    Response res = await videoDetailDataGetter.addVideoComments(
        videoTags, userTag, comment);

    if (res.statusCode == 200) {
      // check if json or not
      if (res.data.toString().contains("successfully")) {
        return DataSuccess("Comment Added Successfully");
      } else {
        return DataFailed("Error on adding comment");
      }
    } else {
      return DataFailed("Error on Internet Connection");
    }
  }

  @override
  Future<DataState<List<SearchVideo>>> getVideoSuggestions(
      String videoTags, String selectvideoTags) async {
    Response res = await videoDetailDataGetter.getVideoSuggestions(
        videoTags, selectvideoTags);
    if (res.statusCode == 200) {
      // check if json or not
      if (isJson(res.data)) {
        List videoList = json.decode(res.data);
        return DataSuccess(
            videoList.map((e) => SearchVideo.fromJson(e)).toList());
      } else {
        return DataFailed(res.data);
      }
    } else {
      return DataFailed("Error on Internet Connection");
    }
  }

  @override
  Future<DataState<String>> submitBookmark(
      String videoTags, String userTag, String status) async {
    Response res = await videoDetailDataGetter.submitBookmark(
      videoTags,
      userTag,
      status,
    );

    if (res.statusCode == 200) {
      // check if json or not
      if (res.data.toString().contains("added successfully")) {
        return DataSuccess("added");
      } else if (res.data.toString().contains("removed successfully")) {
        return DataSuccess("removed");
      } else {
        return DataFailed("error");
      }
    } else {
      return DataFailed("error");
    }
  }

  @override
  Future<DataState<String>> submitLike(
      String videoTags, String userTag, String status) async {
    Response res =
        await videoDetailDataGetter.submitFavorite(videoTags, userTag, status);
    if (res.statusCode == 200) {
      if (res.data.toString().contains("added successfully")) {
        return DataSuccess("added");
      } else if (res.data.toString().contains("removed successfully")) {
        return DataSuccess("removed");
      } else {
        return DataFailed("error");
      }
    } else {
      return DataFailed("error");
    }
  }

  @override
  Future<DataState<LocationModel>> getLocationFromIp() async {
    Response res = await videoDetailDataGetter.getLocationFromIp();
    if (res.statusCode == 200) {
      // if (isJson(res.data)) {

      return DataSuccess(LocationModel.fromJson(json.decode(res.data)));
      // } else {
      // return DataFailed("error");
      // }
    } else {
      return DataFailed("error");
    }
  }

  @override
  Future<DataState<String>> subscribeNotification(
      NotificationSubscribeParams params) async {
    try {
      Response res = await videoDetailDataGetter.subscribeNotification(params);

      if (res.statusCode == 200) {
        if (res.data.toString().contains("successfully")) {
          return DataSuccess("success");
        } else {
          return DataFailed("error");
        }
      } else {
        return DataFailed("unknown error");
      }
    } catch (e) {
      return DataFailed("error on internet connection $e");
    }
  }
}
