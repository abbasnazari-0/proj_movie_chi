import 'package:movie_chi/core/models/search_video_model.dart';
import 'package:movie_chi/core/resources/data_state.dart';

import '../../data/data_sources/remote/data_sources.dart';
import '../../data/models/movies_serias_type_show.dart';

abstract class SeriasMoviesRepository {
  MoviesSeriasDataSource dataSources;
  SeriasMoviesRepository({
    required this.dataSources,
  });

  Future<DataState<List<SearchVideo>>> getSerias(
      int page, String showType, String q);

  Future<DataState<List<SearchVideo>>> getMovies(
      int page, String showType, String q);

  Future<DataState<List<TypeShow>>> getTypeShows();
}
