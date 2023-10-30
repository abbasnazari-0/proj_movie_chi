import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';
import 'package:movie_chi/features/feature_series_movies/domain/repository/serieas_movies_repository.dart';

import '../../data/models/movies_serias_type_show.dart';

class SeriasMoviesUseCases {
  SeriasMoviesRepository seriasMoviesRepository;
  SeriasMoviesUseCases({
    required this.seriasMoviesRepository,
  });

  Future<DataState<HomeCatagory>> getMovies(
      int page, String showType, String q) async {
    return await seriasMoviesRepository.getMovies(page, showType, q);
  }

  Future<DataState<HomeCatagory>> getSerias(
      int page, String showType, String q) async {
    return await seriasMoviesRepository.getSerias(page, showType, q);
  }

  Future<DataState<List<TypeShow>>> getTypeShows() async {
    return await seriasMoviesRepository.getTypeShows();
  }
}
