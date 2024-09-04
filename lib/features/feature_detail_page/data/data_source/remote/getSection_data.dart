import 'package:dio/dio.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';

import '../../../../../core/params/notification_subscribe.dart';

class VideoDetailDataGetter {
  Dio dio = Dio();
  Future<Response> getData(tag, userTag) async {
    var res = await dio
        .post('${Constants.baseUrl()}${pageUrl}video.php', queryParameters: {
      "tag": tag,
      "user_tag": userTag,
      "type": "get",
      "limit": 1,
      "version": await Constants.versionApplication(),
    });

    return res;
  }

  Future<Response> getVideoGallery(galleryId) async {
    var res = dio.post('${Constants.baseUrl()}${pageUrl}photogallery.php',
        queryParameters: {
          "gallery_id": galleryId,
          "version": await Constants.versionApplication(),
        });
    return res;
  }

  // get video comments
  Future<Response> getVideoComments(videoTags, page) async {
    var res = dio
        .post('${Constants.baseUrl()}${pageUrl}comment.php', queryParameters: {
      "video_tags": videoTags,
      "version": await Constants.versionApplication(),
      'user_tag': GetStorageData.getData("user_tag"),
      "type": "get",
      'page': page
    });
    return res;
  }

  Future<Response> reportCommentSpoiler(String commentId) async {
    var res = dio
        .post('${Constants.baseUrl()}${pageUrl}comment.php', queryParameters: {
      "comment_id": commentId,
      "user_tag": GetStorageData.getData("user_tag"),
      "type": "reportSpoiler",
    });
    return res;
  }

  Future<Response> likeComment(int commentId) async {
    var res = dio
        .post('${Constants.baseUrl()}${pageUrl}comment.php', queryParameters: {
      "comment_id": commentId,
      "user_tag": GetStorageData.getData("user_tag"),
      "type": "submitLike",
    });
    return res;
  }

  Future<Response> unikeComment(int commentId) async {
    var res = dio
        .post('${Constants.baseUrl()}${pageUrl}comment.php', queryParameters: {
      "comment_id": commentId,
      "user_tag": GetStorageData.getData("user_tag"),
      "type": "submitDislike",
    });
    return res;
  }

  //  get video comment replies
  Future<Response> getVideoCommentReplies(commentId) async {
    var res = await dio
        .post('${Constants.baseUrl()}${pageUrl}comment.php', queryParameters: {
      "comment_id": commentId,
      "user_tag": GetStorageData.getData("user_tag"),
      "type": "getReply",
    });
    print(res.data);
    return res;
  }

  // submit comment reply
  Future<Response> submitCommentReply(commentId, reply) async {
    var res = dio
        .post('${Constants.baseUrl()}${pageUrl}comment.php', queryParameters: {
      "comment_id": commentId,
      "reply_text": reply,
      "user_tag": GetStorageData.getData("user_tag"),
      "type": "submitReply",
    });
    return res;
  }

  // add video comments
  Future<Response> addVideoComments(videoTags, userTag, comment) async {
    var res = dio
        .post('${Constants.baseUrl()}${pageUrl}comment.php', queryParameters: {
      "comment_vid_tag": videoTags,
      "comment_user_tag": userTag,
      "comment_message": comment,
      "type": "add",
      "version": await Constants.versionApplication(),
    });
    return res;
  }

  // get video suggestions
  Future<Response> getVideoSuggestions(videoTags, selectvideoTags) async {
    var res = await dio.post('${Constants.baseUrl()}${pageUrl}suggestion.php',
        queryParameters: {
          "video_tags": videoTags,
          "video_select_tag": selectvideoTags,
          "user_tag": GetStorageData.getData("user_tag"),
          "version": await Constants.versionApplication(),
        });

    return res;
  }

  // submit bookmark
  Future<Response> submitBookmark(videoTags, userTag, status) async {
    var res = dio.post('${Constants.baseUrl()}${pageUrl}user_bookmark.php',
        queryParameters: {
          "vid_tag": videoTags,
          "user_tag": userTag,
          "type": status,
          "version": await Constants.versionApplication(),
        });
    return res;
  }

  // submit favorite
  Future<Response> submitFavorite(videoTags, userTag, status) async {
    var res = dio.post('${Constants.baseUrl()}${pageUrl}user_favorite.php',
        queryParameters: {
          "vid_tag": videoTags,
          "user_tag": userTag,
          "type": status,
          "version": await Constants.versionApplication(),
        });
    return res;
  }

  // get location from ip
  Future<Response> getLocationFromIp() async {
    var res = await dio.get('${Constants.baseUrl()}${pageUrl}ip.php');

    return res;
  }

  // subscribe notification
  Future<Response> subscribeNotification(
      NotificationSubscribeParams notifParams) async {
    var res = dio.post(
        '${Constants.baseUrl()}${pageUrl}notification_movies.php',
        queryParameters: {
          "user_tag": notifParams.userTag,
          "type": notifParams.status,
          "version": await Constants.versionApplication(),
          "user_token": notifParams.userToken,
          "tag": notifParams.tag,
        });
    return res;
  }
}
