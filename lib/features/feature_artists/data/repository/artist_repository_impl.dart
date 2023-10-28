import 'package:dio/dio.dart';
import 'package:movie_chi/core/models/search_video_model.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_artists/data/models/artist_data_model.dart';
import 'package:movie_chi/features/feature_artists/data/models/artist_videos_model.dart';
import 'package:movie_chi/features/feature_artists/domain/repositories/artist_repostitory.dart';

class ArtistReositoryImpl extends ArtistRepository {
  ArtistReositoryImpl({required super.artistGetter});

  @override
  Future<DataState<List<ArtistItemData>>> getArtistSuggestionData(
      int itemCount, int page, String? artistName, String? artistTag) async {
    try {
      Response res = await artistGetter.getArtistSuggestionData(
          itemCount, page, artistName, artistTag);
      if (res.statusCode == 200) {
        ArtistModels artistModels = ArtistModels.fromJson(res.data);

        List<ArtistItemData> artistList = [];
        artistModels.result?.forEach((element) {
          artistList.add(element);
        });
        return (DataSuccess(artistList));
      } else {
        return (DataFailed(res.data));
      }
    } catch (e) {
      return DataFailed("error in ineternt $e");
    }
  }

  @override
  Future<DataState<List<SearchVideo>>> getArtistData(
      int itemCount, int page, String? artistName, String? artistTag) async {
    try {
      Response res = await artistGetter.getArtistData(
          itemCount, page, artistName, artistTag);
      if (res.statusCode == 200) {
        List<SearchVideo> artistList = [];
        ArtistVideoData artistVideoData = ArtistVideoData.fromJson(res.data);

        artistVideoData.result?.forEach((element) {
          artistList.add(element);
        });
        return (DataSuccess(artistList));
      } else {
        return (DataFailed(res.data));
      }
    } catch (e) {
      return DataFailed("error in ineternt $e");
    }
  }
}
