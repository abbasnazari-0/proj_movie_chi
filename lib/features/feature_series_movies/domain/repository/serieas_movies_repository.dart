import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';

import '../../data/data_sources/remote/data_sources.dart';
import '../../data/models/movies_serias_type_show.dart';

abstract class SeriasMoviesRepository {
  MoviesSeriasDataSource dataSources;
  SeriasMoviesRepository({
    required this.dataSources,
  });

  Future<DataState<HomeCatagory>> getSerias(
      int page, String showType, String q);

  Future<DataState<HomeCatagory>> getMovies(
      int page, String showType, String q);

  Future<DataState<List<TypeShow>>> getTypeShows();
}
