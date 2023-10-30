import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';
import 'package:movie_chi/features/feature_series_movies/data/models/movies_serias_type_show.dart';
import 'package:movie_chi/features/feature_series_movies/domain/repository/serieas_movies_repository.dart';

class SeriasMoviesRepositoryImpl extends SeriasMoviesRepository {
  SeriasMoviesRepositoryImpl({required super.dataSources});

  @override
  Future<DataState<HomeCatagory>> getMovies(
      int page, String showType, String q) async {
    try {
      var res = await dataSources.getMovies(page, showType, q);

      if (res.statusCode == 200) {
        //   List<SearchVideo> searchVideo = [];
        //   res.data["data"].forEach((element) {
        //     searchVideo.add(SearchVideo.fromJson(element));
        //   });

        return DataSuccess(HomeCatagory.fromJson((res.data)));
      } else {
        return DataFailed("somthing went error!");
      }
    } catch (ee) {
      return DataFailed("error on internet");
    }
  }

  @override
  Future<DataState<HomeCatagory>> getSerias(
      int page, String showType, String q) async {
    try {
      var res = await dataSources.getSerias(page, showType, q);

      if (res.statusCode == 200) {
        // List<SearchVideo> searchVideo = [];
        // res.data["data"].forEach((element) {
        //   searchVideo.add(SearchVideo.fromJson(element));
        // });
        // return DataSuccess(searchVideo);

        return DataSuccess(HomeCatagory.fromJson(res.data));
      } else {
        return DataFailed("somthing went error!");
      }
    } catch (ee) {
      return DataFailed("error on internet $ee");
    }
  }

  @override
  Future<DataState<List<TypeShow>>> getTypeShows() async {
    try {
      var res = await dataSources.getTypeShows();
      if (res.statusCode == 200) {
        List<TypeShow> typeShow = [];
        res.data.forEach((element) {
          typeShow.add(TypeShow.fromJson(element));
        });
        return DataSuccess(typeShow);
        // print(res.data);
        // return DataSuccess(HomeCatagory.fromJson((res.data)));
      } else {
        return DataFailed("somthing went error!");
      }
    } catch (ee) {
      return DataFailed("error on internet $ee");
    }
  }
}
