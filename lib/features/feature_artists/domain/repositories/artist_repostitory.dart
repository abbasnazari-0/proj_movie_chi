import 'package:movie_chi/core/models/search_video_model.dart';
import 'package:movie_chi/features/feature_artists/data/data_sources/remotes/artist_getter_source.dart';
import 'package:movie_chi/features/feature_artists/data/models/artist_data_model.dart';

import '../../../../core/resources/data_state.dart';

abstract class ArtistRepository {
  ArtistGetter artistGetter;
  ArtistRepository({
    required this.artistGetter,
  });

  Future<DataState<List<ArtistItemData>>> getArtistSuggestionData(
      int itemCount, int page, String? artistName, String? artistTag);

  Future<DataState<List<SearchVideo>>> getArtistData(
      int itemCount, int page, String? artistName, String? artistTag);
}
