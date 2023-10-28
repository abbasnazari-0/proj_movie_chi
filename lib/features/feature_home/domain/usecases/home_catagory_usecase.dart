import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_home/data/model/home_reels_model.dart';
import 'package:movie_chi/features/feature_home/data/model/reel_comment_model.dart';

import '../../../../core/params/home_request_params.dart';
import '../../../feature_detail_page/data/model/location_ip_model.dart';
import '../../../../core/models/search_video_model.dart';
import '../../../feature_artists/data/models/artist_data_model.dart';
import '../../data/model/home_catagory_model.dart';
import '../repositories/home_cataogry_repository.dart';

class HomeCatagoryUseCase {
  final HomeCategoryRepository homeCatagoryRepository;
  HomeCatagoryUseCase(this.homeCatagoryRepository);
  Future<DataState<HomeCatagory>> getHomeCatagory(
      HomeRequestParams homeRequestParams) async {
    return await homeCatagoryRepository.getHomeCategory(homeRequestParams);
  }

  // Future<DataState<HomeCatagagoryItemModel>> getHomeCatagoryItemData(
  //     List vidIds, String title) async {
  //   return await homeCatagoryRepository.getHomeCategoryItemData(vidIds, title);
  // }

  Future<DataState<List<ReelsModel>>> getReelsData(
      String userTag, int count) async {
    return await homeCatagoryRepository.getReelsData(userTag, count);
  }

  Future<DataState<String>> likeOrDeslikeReelPost(
      String userTag, String videTag, String type) async {
    return await homeCatagoryRepository.likeOrDeslikeReelPost(
        userTag, videTag, type);
  }

  Future<DataState<List<ReelsCommentModel>>> getReelComment(
      String vidTag) async {
    return await homeCatagoryRepository.getReelComment(vidTag);
  }

  Future<DataState<String>> submitReelComment(
      String userTag, String vidTag, String comment) async {
    return await homeCatagoryRepository.submitReelComment(
        userTag, vidTag, comment);
  }

  Future<DataState<List<SearchVideo>>> getBookmarkedVideo(
      String userTag) async {
    return await homeCatagoryRepository.getBookmarkedVideo(userTag);
  }

  Future<DataState<List<SearchVideo>>> getFavoriteVideo(String userTag) async {
    return await homeCatagoryRepository.getFavoriteVideo(userTag);
  }

  Future<DataState<String>> getUpdateAvailable() async {
    return await homeCatagoryRepository.getUpdateAvailable();
  }

  Future<DataState<LocationModel>> getLocationFromIp() async {
    return await homeCatagoryRepository.getLocationFromIp();
  }

  Future<DataState<String>> getAppConfig() async {
    return await homeCatagoryRepository.getAppConfig();
  }

  Future<DataState<List<ArtistItemData>>> getArtistSuggestionData(
      int itemCount, int page, String? artistName, String? artistTag) async {
    return await homeCatagoryRepository.getArtistSuggestionData(
      itemCount,
      page,
    );
  }
}
