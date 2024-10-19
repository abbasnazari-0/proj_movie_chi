import 'dart:io';

import 'package:get/get.dart';
import 'package:movie_chi/core/screens/splash_screen.dart';
import 'package:movie_chi/core/screens/splash_screen_ios.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/photo_viewer_screen.dart';
import 'package:movie_chi/features/feature_artists/presentation/pages/artist_list.dart';
import 'package:movie_chi/features/feature_artists/presentation/pages/feature_artist.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/pages/detail_page.dart';
import 'package:movie_chi/features/feature_home/presentation/pages/feature_home_screen.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_login_screen.dart';
import 'package:movie_chi/features/feature_play_list/presentation/pages/feature_play_list.dart';
import 'package:movie_chi/features/feature_zhanner/presentation/pages/zhanner_detail.dart';

final List<GetPage> routes = [
  Platform.isIOS && (GetStorageData.getData('Authorizedd') ?? false) == false
      ? GetPage(
          name: "/",
          page: () => const SplashIOS(),
        )
      : GetPage(
          name: "/",
          page: () => const Splash(),
        ),
  GetPage(
    name: "/home",
    page: () => const HomeScreen(),
  ),
  GetPage(
    name: "/detail",
    page: () => const DetailPage(),
  ),
  //  PhotoViewer
  GetPage(
    name: "/photoViewer",
    page: () => PhotoViewer(),
  ),
  GetPage(
    name: "/artist",
    page: () => ArtistPage(),
    // transition: Transition.cupertino,
  ),

  GetPage(
    name: "/artist_list",
    page: () => const ArtistList(),
    transition: Transition.downToUp,
  ),
  GetPage(
      name: "/play_list",
      page: () => PlayListScreen(),
      transition: Transition.circularReveal),
  // ZhannerDetail
  GetPage(
    name: "/zhannerDetail",
    page: () => ZhannerDetail(),
  ),
  GetPage(name: '/login_screen', page: () => LoginScreen()),
];
