import 'package:movie_chi/core/models/search_video_model.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_series_movies/domain/repository/serieas_movies_repository.dart';

import '../../data/models/movies_serias_type_show.dart';

class SeriasMoviesUseCases {
  SeriasMoviesRepository seriasMoviesRepository;
  SeriasMoviesUseCases({
    required this.seriasMoviesRepository,
  });

  Future<DataState<List<SearchVideo>>> getMovies(
      int page, String showType, String q) async {
    return await seriasMoviesRepository.getMovies(page, showType, q);
  }

  Future<DataState<List<SearchVideo>>> getSerias(
      int page, String showType, String q) async {
    return await seriasMoviesRepository.getSerias(page, showType, q);
  }

  Future<DataState<List<TypeShow>>> getTypeShows() async {
    return await seriasMoviesRepository.getTypeShows();
  }
}
