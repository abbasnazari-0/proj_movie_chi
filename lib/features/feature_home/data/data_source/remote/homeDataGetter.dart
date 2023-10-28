import 'package:dio/dio.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';

import '../../../../../core/params/home_request_params.dart';
import '../../../../../core/utils/constants.dart';

class HomeDataGetter {
  Dio dio = Dio();
  // get location from ip
  Future<Response> getLocationFromIp() async {
    var res = await dio.get('${Constants.baseUrl()}${pageUrl}ip.php');

    return res;
  }

  //get data with http
  Future<Response> getData(HomeRequestParams homeRequestParams) async {
    var res = await dio.post('${Constants.baseUrl()}${pageUrl}home.php',
        queryParameters: homeRequestParams.toMap());

    return res;
  }

  // get catagory item data
  Future<Response> getCatagoryItemData(List list, String title) async {
    var res = await dio
        .post('${Constants.baseUrl()}${pageUrl}catagory.php', queryParameters: {
      'vid_ids': list.toString(),
      "title": title,
      "version": await Constants.versionApplication(),
    });
    return res;
  }

  // get reels data
  Future<Response> getReelsData(String userTag, int count) async {
    var res = await dio
        .post('${Constants.baseUrl()}${pageUrl}reels.php', queryParameters: {
      "user_tag": userTag,
      "count": count,
      "version": await Constants.versionApplication(),
    });

    return res;
  }

  // like or deslike reel post
  Future<Response> likeOrDeslikeReelPost(
      String userTag, String videTag, String type) async {
    var res = await dio.post('${Constants.baseUrl()}${pageUrl}reels_like.php',
        queryParameters: {
          "type": type,
          "user_tag": userTag,
          "vid_tag": videTag,
          "version": await Constants.versionApplication(),
        });
    return res;
  }

  // get reel comment
  Future<Response> getReelComment(String vidTag) async {
    var res = await dio.post(
        '${Constants.baseUrl()}${pageUrl}reels_comment.php',
        queryParameters: {
          "vid_tag": vidTag,
          "type": "get",
          "version": await Constants.versionApplication(),
        });
    return res;
  }

  // submit reel comment
  Future<Response> submitReelComment(
      String userTag, String vidTag, String comment) async {
    var res = await dio.post(
        '${Constants.baseUrl()}${pageUrl}reels_comment.php',
        queryParameters: {
          "type": "submit",
          "comment_user_tag": userTag,
          "comment_vid_tag": vidTag,
          "comment_message": comment,
          "version": await Constants.versionApplication(),
        });
    return res;
  }

  // get user bookmark
  Future<Response> getUserBookmark(String userTag) async {
    var res = await dio.post(
        '${Constants.baseUrl()}${pageUrl}user_bookmark.php',
        queryParameters: {
          "user_tag": userTag,
          "type": "get",
          "version": await Constants.versionApplication(),
        });
    return res;
  } // get user bookmark

  Future<Response> getUserFavorite(String userTag) async {
    var res = await dio.post(
        '${Constants.baseUrl()}${pageUrl}user_favorite.php',
        queryParameters: {
          "user_tag": userTag,
          "type": "get",
          "version": await Constants.versionApplication(),
        });

    return res;
  }

  // get update available
  Future<Response> getUpdateAvailable() async {
    // get vesion code

    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String version = "23"; //packageInfo.version;

    var res = await dio
        .post('${Constants.baseUrl()}${pageUrl}update.php', queryParameters: {
      "type": "get",
      "version": await Constants.versionApplication(),
    });
    return res;
  }

  Future<Response> getAppConfig() async {
    var res = await dio.get(
      'https://raw.githubusercontent.com/mosbahsofttechnology/cinimo/main/config.txt',
    );
    return res;
  }

  getArtistSuggestionData(int itemCount, int page) {
    return dio
        .get('${Constants.baseUrl()}${pageUrl}artist.php', queryParameters: {
      "type": "get",
      "version": Constants.versionApplication(),
      "mtype": "suggestion",
      "user_tag": GetStorageData.getData("user_tag") ?? "",
      "limit": itemCount,
      "page": page
    });
  }
}
