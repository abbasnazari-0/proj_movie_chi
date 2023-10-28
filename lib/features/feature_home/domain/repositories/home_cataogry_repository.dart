import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_home/data/data_source/remote/homeDataGetter.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';
import 'package:movie_chi/core/models/search_video_model.dart';

import '../../../../core/params/home_request_params.dart';
import '../../../feature_detail_page/data/model/location_ip_model.dart';
import '../../../feature_artists/data/models/artist_data_model.dart';
import '../../data/model/home_catagory_item_model.dart';
import '../../data/model/home_reels_model.dart';
import '../../data/model/reel_comment_model.dart';

abstract class HomeCategoryRepository {
  final HomeDataGetter homeCategoryDataGetter;
  // final

  HomeCategoryRepository(this.homeCategoryDataGetter);

  Future<DataState<HomeCatagory>> getHomeCategory(
      HomeRequestParams homeRequestParams);

  Future<DataState<HomeCatagagoryItemModel>> getHomeCategoryItemData(
      List vidIds, String title);

  Future<DataState<List<ReelsModel>>> getReelsData(String userTag, int count);

  // like or deslike reel post
  Future<DataState<String>> likeOrDeslikeReelPost(
      String userTag, String videTag, String type);

  // get reel comment
  Future<DataState<List<ReelsCommentModel>>> getReelComment(String vidTag);

  // submit reel comment
  Future<DataState<String>> submitReelComment(
      String userTag, String vidTag, String comment);

  // get bookmarked video
  Future<DataState<List<SearchVideo>>> getBookmarkedVideo(String userTag);

  // get favorite video
  Future<DataState<List<SearchVideo>>> getFavoriteVideo(String userTag);
  // get version number of app
  Future<DataState<String>> getUpdateAvailable();

  Future<DataState<LocationModel>> getLocationFromIp();

  Future<DataState<String>> getAppConfig();

  Future<DataState<List<ArtistItemData>>> getArtistSuggestionData(
    int itemCount,
    int page,
  );
}
