import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_chi/features/feature_artists/data/models/artist_data_model.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';
import 'package:movie_chi/features/feature_home/data/data_source/remote/homeDataGetter.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_home/data/model/home_reels_model.dart';
import 'package:movie_chi/features/feature_home/data/model/reel_comment_model.dart';
import 'package:movie_chi/features/feature_home/domain/repositories/home_cataogry_repository.dart';
import 'package:movie_chi/core/models/search_video_model.dart';

import '../../../../core/params/home_request_params.dart';
import '../../../../core/utils/json_checker.dart';
import '../../../feature_detail_page/data/model/location_ip_model.dart';
import '../model/home_catagory_item_model.dart';

class HomeCategoryRepositoryImpl implements HomeCategoryRepository {
  @override
  final HomeDataGetter homeCategoryDataGetter;

  HomeCategoryRepositoryImpl(this.homeCategoryDataGetter);

  int homeDataRetireis = 0;

  @override
  Future<DataState<HomeCatagory>> getHomeCategory(
      HomeRequestParams homeRequestParams) async {
    Response res = await homeCategoryDataGetter.getData(homeRequestParams);

    if (res.statusCode == 200) {
      // check if json or not
      // if (isJson(res.data)) {
      // List homeCatagoryList = json.decode(res.data);

      try {
        return DataSuccess(HomeCatagory.fromJson((res.data)));
      } catch (e) {
        if (homeDataRetireis < 2) {
          homeDataRetireis++;
          return getHomeCategory(homeRequestParams);
        }
        return DataFailed(e.toString());
      }
      // } else {
      //   return DataFailed(res.data);
      // }
    } else {
      if (homeDataRetireis < 2) {
        homeDataRetireis++;
        return getHomeCategory(homeRequestParams);
      }
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<HomeCatagagoryItemModel>> getHomeCategoryItemData(
      List vidIds, String title) async {
    Response res =
        await homeCategoryDataGetter.getCatagoryItemData(vidIds, title);
    if (res.statusCode == 200) {
      // check if json or not
      if (isJson(res.data)) {
        return DataSuccess(
            HomeCatagagoryItemModel.fromJson(json.decode(res.data)));
      } else {
        return DataFailed(res.data);
      }
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<List<ReelsModel>>> getReelsData(
      String userTag, int count) async {
    Response res = await homeCategoryDataGetter.getReelsData(userTag, count);

    if (res.statusCode == 200) {
      // check if json or not
      if (isJson(res.data)) {
        List reelData = json.decode(res.data);

        return DataSuccess(
            reelData.map((e) => ReelsModel.fromJson(e)).toList());
      } else {
        return DataFailed(res.data);
      }
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<String>> likeOrDeslikeReelPost(
      String userTag, String videTag, String type) async {
    Response res = await homeCategoryDataGetter.likeOrDeslikeReelPost(
        userTag, videTag, type);

    if (res.statusCode == 200) {
      // check if json or not
      return DataSuccess(res.data);
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<List<ReelsCommentModel>>> getReelComment(
      String vidTag) async {
    Response res = await homeCategoryDataGetter.getReelComment(vidTag);

    if (res.statusCode == 200) {
      // check if json or not
      if (isJson(res.data)) {
        List reelCommentData = json.decode(res.data);

        return DataSuccess(
            reelCommentData.map((e) => ReelsCommentModel.fromJson(e)).toList());
      } else {
        return DataFailed(res.data);
      }
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<String>> submitReelComment(
      String userTag, String vidTag, String comment) async {
    Response res = await homeCategoryDataGetter.submitReelComment(
        userTag, vidTag, comment);

    if (res.statusCode == 200) {
      return DataSuccess(res.data);
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<List<SearchVideo>>> getBookmarkedVideo(
      String userTag) async {
    Response res = await homeCategoryDataGetter.getUserBookmark(userTag);

    if (res.statusCode == 200) {
      // check if json or not
      if (isJson(res.data)) {
        List bookmarkedVideo = json.decode(res.data);

        return DataSuccess(
            bookmarkedVideo.map((e) => SearchVideo.fromJson(e)).toList());
      } else {
        return DataFailed(res.data);
      }
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<String>> getUpdateAvailable() async {
    Response res = await homeCategoryDataGetter.getUpdateAvailable();

    if (res.statusCode == 200) {
      // check if json or not

      return DataSuccess(res.data);
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<LocationModel>> getLocationFromIp() async {
    Response res = await homeCategoryDataGetter.getLocationFromIp();
    if (res.statusCode == 200) {
      // if (isJson(res.data)) {
      // print(res.data);

      return DataSuccess(LocationModel.fromJson(json.decode(res.data)));
      // } else {
      // return DataFailed("error");
      // }
    } else {
      return DataFailed("error");
    }
  }

  @override
  Future<DataState<List<SearchVideo>>> getFavoriteVideo(String userTag) async {
    Response res = await homeCategoryDataGetter.getUserFavorite(userTag);

    if (res.statusCode == 200) {
      // check if json or not
      if (isJson(res.data)) {
        List favoriteVideo = json.decode(res.data);

        return DataSuccess(
            favoriteVideo.map((e) => SearchVideo.fromJson(e)).toList());
      } else {
        return DataFailed(res.data);
      }
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<String>> getAppConfig() async {
    Response res = await homeCategoryDataGetter.getAppConfig();

    if (res.statusCode == 200) {
      // check if json or not
      // if (isJson(res.data)) {
      return DataSuccess(res.data);
      // } else {
      //   return DataFailed(res.data);
      // }
    } else {
      return DataFailed(res.statusMessage);
    }
  }

  @override
  Future<DataState<List<ArtistItemData>>> getArtistSuggestionData(
      int itemCount, int page) async {
    Response res =
        await homeCategoryDataGetter.getArtistSuggestionData(itemCount, page);

    try {
      if (res.statusCode == 200) {
        ArtistModels artistModels = ArtistModels.fromJson(res.data);
        if (artistModels.status == "success") {
          return DataSuccess(artistModels.result!);
        } else {
          return DataFailed(artistModels.status!);
        }
      } else {
        return DataFailed(res.statusMessage);
      }
    } catch (ee) {
      return DataFailed("error in internet connection");
    }
  }
}
