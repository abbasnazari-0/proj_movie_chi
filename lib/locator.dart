import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie_chi/features/feature_artists/data/data_sources/remotes/artist_getter_source.dart';
import 'package:movie_chi/features/feature_artists/data/repository/artist_repository_impl.dart';
import 'package:movie_chi/features/feature_artists/domain/repositories/artist_repostitory.dart';
import 'package:movie_chi/features/feature_artists/domain/usecase/artist_page_usecase.dart';
import 'package:movie_chi/features/feature_catagory/data/data_source/remote/dataGettercatagory.dart';
import 'package:movie_chi/features/feature_catagory/data/repositories/catagory_respository_impl.dart';
import 'package:movie_chi/features/feature_catagory/domain/repositories/catagory_repository.dart';
import 'package:movie_chi/features/feature_catagory/domain/useacases/catagory_usecase.dart';
import 'package:movie_chi/features/feature_catagory/presentation/bloc/catagory_bloc.dart';
import 'package:movie_chi/features/feature_detail_page/data/data_source/remote/getSection_data.dart';
import 'package:movie_chi/features/feature_detail_page/domain/repositories/video_detail_repository.dart';
import 'package:movie_chi/features/feature_detail_page/domain/usecases/video_detail_usecase.dart';
import 'package:movie_chi/features/feature_new_notification/data/data_source/remote.dart';
import 'package:movie_chi/features/feature_new_notification/data/repository/news_repository_impl.dart';
import 'package:movie_chi/features/feature_new_notification/domain/repository/news_repository.dart';
import 'package:movie_chi/features/feature_new_notification/domain/usecases/news_use_case.dart';
import 'package:movie_chi/features/feature_plans/data/data_source/data_source.dart';
import 'package:movie_chi/features/feature_plans/data/repositories/plan_repository_impl.dart';
import 'package:movie_chi/features/feature_plans/domain/repositories/plan_repositry.dart';
import 'package:movie_chi/features/feature_plans/domain/usecase/plan_usecase.dart';
import 'package:movie_chi/features/feature_series_movies/data/data_sources/remote/data_sources.dart';
import 'package:movie_chi/features/feature_support/data/data_source/remote.dart';
import 'package:movie_chi/features/feature_support/data/repository/support_repository_impl.dart';
import 'package:movie_chi/features/feature_support/domain/repository/support_repository.dart';
import 'package:movie_chi/features/feature_support/domain/usecases/support_use_case.dart';
import 'package:movie_chi/features/feature_zhanner/data/data_source/remote/zhanner_data_source.dart';
import 'package:movie_chi/features/feature_home/data/respository/home_catagory_repository_impl.dart';
import 'package:movie_chi/features/feature_home/domain/repositories/home_cataogry_repository.dart';
import 'package:movie_chi/features/feature_zhanner/domain/repositories/zhanner_repository.dart';
import 'package:movie_chi/features/feature_home/domain/usecases/home_catagory_usecase.dart';
import 'package:movie_chi/features/feature_login_screen/domain/repositories/otp_repository.dart';
import 'package:movie_chi/features/feature_login_screen/domain/usecase/otp_usecase.dart';
import 'package:movie_chi/features/feature_play_list/data/data_sources/remote/play_list_data_getter.dart';
import 'package:movie_chi/features/feature_play_list/domain/repositories/play_list_repository.dart';
import 'package:movie_chi/features/feature_search/data/data_source/remote/searchGetData.dart';
import 'package:movie_chi/features/feature_search/data/respository/search_repository_impl.dart';
import 'package:movie_chi/features/feature_search/domain/repositories/search_repository.dart';
import 'package:movie_chi/features/feature_search/domain/usecases/search_usecase.dart';
import 'package:movie_chi/features/feature_video_player/data/respository/video_player_repository_impl.dart';
import 'package:movie_chi/features/feature_video_player/domain/usecases/video_player_usecase.dart';

import 'core/utils/database_helper.dart';
import 'features/feature_detail_page/data/respository/video_detail_repository_impl.dart';
import 'features/feature_home/data/data_source/remote/homeDataGetter.dart';
import 'features/feature_series_movies/data/repository/serias_movies_repository_impl.dart';
import 'features/feature_series_movies/domain/repository/serieas_movies_repository.dart';
import 'features/feature_series_movies/domain/usecases/serias_movies_use_cases.dart';
import 'features/feature_zhanner/data/repository/zhanner_repository_impl.dart';
import 'features/feature_zhanner/domain/usecases/zhnnaer_usecase.dart';
import 'features/feature_login_screen/data/data_source/data_source.dart';
import 'features/feature_login_screen/data/repositories/otp_repository_impl.dart';
import 'features/feature_play_list/data/repositories/play_list_repository_impl.dart';
import 'features/feature_play_list/domain/usecases/play_list_usecase.dart';
import 'features/feature_video_player/data/data_source/remote/video_data_reporter.dart';
import 'features/feature_video_player/domain/repositories/video_player_repository.dart';

GetIt locator = GetIt.instance;

locatConfigSecoundPage() {
  // locator.registerSingleton<DownloadPageController>(DownloadPageController());

  // locator.registerSingleton<AdController>(AdController());
  // Get.put(AdController());
}

setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  locator.registerSingleton<DataGetterCatagory>(DataGetterCatagory());
  locator
      .registerSingleton<CatagoryRepository>(CatagroyRepositoryImpl(locator()));
  locator.registerSingleton<CatagoryUseCase>(CatagoryUseCase(locator()));

  locator.registerSingleton<CatagoryBloc>(CatagoryBloc(locator()));

  await GetStorage.init();

  locator.registerSingleton<SearchDataGetter>(SearchDataGetter());
  locator.registerSingleton<SearchRepository>(
      SearchReposityImpl(searchDataGetter: locator()));
  locator.registerSingleton<SearchUseCase>(SearchUseCase(locator()));

  locator.registerSingleton<VideoDetailDataGetter>(VideoDetailDataGetter());
  locator.registerSingleton<VideoDetailRepository>(
      VideoDetailRepositoryImpl(locator()));
  locator.registerSingleton<VideoDetailUseCase>(VideoDetailUseCase(locator()));

  locator.registerSingleton<HomeDataGetter>(HomeDataGetter());
  locator.registerSingleton<HomeCategoryRepository>(
      HomeCategoryRepositoryImpl(locator()));
  locator
      .registerSingleton<HomeCatagoryUseCase>(HomeCatagoryUseCase(locator()));

  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<OTPRepository>(OTPRepsitoryImpl(locator()));
  locator.registerSingleton<OTPUseCase>(OTPUseCase(locator()));

  locator.registerSingleton<VideoDataReporter>(VideoDataReporter());
  locator.registerSingleton<VideoPlayerRepositry>(
      VideoPlayerRepositoryImpl(locator()));
  locator.registerSingleton<VideoPlayerUseCase>(VideoPlayerUseCase(locator()));

  locator.registerSingleton<PlayListDataGetter>(PlayListDataGetter());
  locator.registerSingleton<PlayListRepo>(PlayListRepositoryImpl(locator()));
  locator.registerSingleton<PlayListUseCase>(PlayListUseCase(locator()));

  locator.registerSingleton<ZhannerDataSource>(ZhannerDataSource());
  locator.registerSingleton<ZhannerRepository>(
      ZhannerRepositoryImpl(zhannerDataSource: locator()));
  locator.registerSingleton<ZhannerUseCase>(
      ZhannerUseCase(zhannerRepository: locator()));

  locator.registerSingleton<ArtistGetter>(ArtistGetter());
  locator.registerSingleton<ArtistRepository>(
      ArtistReositoryImpl(artistGetter: locator()));
  locator.registerSingleton<ArtistPageUseCases>(
      ArtistPageUseCases(artistRepository: locator()));

  locator
      .registerSingleton<DictionaryDataBaseHelper>(DictionaryDataBaseHelper());

  locator.registerSingleton<MoviesSeriasDataSource>(MoviesSeriasDataSource());
  locator.registerSingleton<SeriasMoviesRepository>(
      SeriasMoviesRepositoryImpl(dataSources: locator()));

  locator.registerSingleton<SeriasMoviesUseCases>(
      SeriasMoviesUseCases(seriasMoviesRepository: locator()));

  locator.registerSingleton<PlanApiProvider>(PlanApiProvider());
  locator.registerSingleton<PlanRepository>(PlanRepositoryImpl(locator()));
  locator.registerSingleton<PlanUseCase>(PlanUseCase(locator()));

  locator.registerSingleton<SupportApiProvider>(SupportApiProvider());
  locator.registerSingleton<SupportRepository>(
      SupportRepositoryImpl(apiProvider: locator()));
  locator
      .registerSingleton<SupportUseCase>(SupportUseCase(repository: locator()));

  locator.registerSingleton<NewsApiProvider>(NewsApiProvider());
  locator.registerSingleton<NewsRepository>(
      NewsRepostiryImpl(apiProvider: locator()));
  locator.registerSingleton<NewsUseCase>(NewsUseCase(repository: locator()));

  locatConfigSecoundPage();
/*
  //Init Firebase Remot Config
  locator
      .registerSingleton<FirebaseRemoteConfig>(FirebaseRemoteConfig.instance);

  await locator<FirebaseRemoteConfig>().setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(minutes: 5),
  ));

  await locator<FirebaseRemoteConfig>().fetchAndActivate();

  //Init Firebase By Checking platforms
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    if (Platform.isAndroid || Platform.isIOS) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (Platform.isAndroid) {
        //If is Android
        TapsellPlus.instance.initialize(
            'cfsmnptkpgccjpccojhlakgkimajspklnmrtrjtesoqkcaammqfqeffththclelgajnpfq');
      } else {
        //If is ios
      }
    } else if (Platform.isFuchsia) {
    } else if (Platform.isLinux) {
    } else if (Platform.isMacOS) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else if (Platform.isWindows) {}
  }*/
}
