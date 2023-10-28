// // ignore_for_file: avoid_print

// import 'dart:async';
// import 'dart:convert';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

// import 'package:pod_player/pod_player.dart';

// import 'package:movie_chi/features/feature_detail_page/presentation/widgets/play_button.dart';

// import 'package:movie_chi/features/feature_video_player/data/data_source/remote/vide_data_getter.dart';
// import 'package:movie_chi/features/feature_video_player/presentation/widgets/snackbar_controller.dart';

// import '../../../../core/widgets/mytext.dart';

// class MyVideoPlayer2 extends StatefulWidget {
//   MyVideoPlayer2({
//     Key? key,
//     required this.map_data,
//   }) : super(key: key);
//   Map map_data;

//   @override
//   State<MyVideoPlayer2> createState() => _MyVideoPlayerState();
// }

// class _MyVideoPlayerState extends State<MyVideoPlayer2> {
//   // BannerAd? _mybannerAd;
//   bool isBannerAdLoaded = false;
//   // RewardedAd? _myRewardedAd;
//   bool isInterstitialAdLoaded = true;
//   bool isRewardedAdLoaded = false;
//   List secdata = [];

//   ///------Tapsell Respone------///
//   String responserewarded = '';
//   String responsebanner = '';
//   String responseInterstitial = '';

//   late Map map_data;

//   late PodPlayerController controller;

//   Duration? videoDuration;
//   Duration? videoPosition;
//   int adPosition = 0;
//   late List<double> adTimes = [];
//   StreamSubscription? _streamSubscription;

//   bool loadAdFullSceeen = true;
//   bool isControllerInit = false;

//   checkVideos() async {
//     print('-------> Start');
//     controller.addListener(() async {
//       if (controller.videoPlayerValue!.isInitialized) {
//         if (controller.videoPlayerValue?.duration.inSeconds != null) {
//           videoDuration = controller.videoPlayerValue?.duration;
//         }
//         //Set Position
//         if (controller.videoPlayerValue?.position.inSeconds != null) {
//           videoPosition = controller.videoPlayerValue?.position;
//         }
//       }

//       if (controller.videoPlayerValue!.isInitialized &&
//           videoDuration != null &&
//           adTimes.isEmpty) {
//         adTimes.add(1);

//         adTimes.add((videoDuration!.inSeconds / 5) * 1);
//         adTimes.add((videoDuration!.inSeconds / 5) * 2);
//         adTimes.add((videoDuration!.inSeconds / 5) * 3);
//         adTimes.add((videoDuration!.inSeconds / 5) * 4);
//       }

//       if (adTimes.isNotEmpty && adPosition < adTimes.length) {
//         if (videoPosition!.inSeconds > adTimes[adPosition].toInt()) {
//           print('-------> Ad Time Showed');

//           if (loadAdFullSceeen) {
//             loadAdFullSceeen = false;
//             createRewardedAd();
//           }
//           adPosition++;
//         }
//       }
//     });
//   }

//   PlayVideoFrom loadWithYoutube() {
//     return PlayVideoFrom.youtube(map_data['vid_240']);
//   }

//   PlayVideoFrom loadWithUrls() {
//     return PlayVideoFrom.networkQualityUrls(
//       videoUrls: [
//         if (map_data['vid_240'] != null && map_data['vid_240'] != '')
//           VideoQalityUrls(
//             quality: 240,
//             url: map_data['vid_240'],
//           ),
//         if (map_data['vid_360'] != null && map_data['vid_360'] != '')
//           VideoQalityUrls(
//             quality: 360,
//             url: map_data['vid_360'],
//           ),
//         if (map_data['vid_480'] != null && map_data['vid_480'] != '')
//           VideoQalityUrls(
//             quality: 480,
//             url: map_data['vid_480'],
//           ),
//         if (map_data['vid_720'] != null && map_data['vid_720'] != '')
//           VideoQalityUrls(
//             quality: 720,
//             url: map_data['vid_720'],
//           ),
//       ],
//     );
//   }

//   void videoLoader(bool changed) async {
//     isControllerInit = true;
//     if (changed) {
//       controller.changeVideo(
//         playVideoFrom: map_data['vid_240'].toString().contains('youtu')
//             ? loadWithYoutube()
//             : loadWithUrls(),
//       );

//       return;
//     }

//     controller = PodPlayerController(
//         playVideoFrom: map_data['vid_240'].toString().contains('youtu')
//             ? loadWithYoutube()
//             : loadWithUrls())
//       ..initialise().onError((error, stackTrace) {
//         print('---------> $error');
//       });
//   }

//   playerDuration() async {
//     checkVideos();
//   }

//   void changeStatusBarColor(bool isStarted) async {
//     if (isStarted) {
//       await FlutterStatusbarcolor.setStatusBarColor(Colors.black);
//     } else {
//       await FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     changeStatusBarColor(true);

//     map_data = widget.map_data;
//     videoLoader(false);

//     playerDuration();
//     // createBannerAd();
//   }

//   // createBannerAd() async {
//   //   Appodeal.setBannerCallbacks(onBannerLoaded: (loaded) {
//   //     print('------------------------------>dds$loaded');
//   //   });
//   //   isBannerAdLoaded = await Appodeal.show(AppodealAdType.BannerBottom);
//   //   if (!isBannerAdLoaded) {
//   //     // showTapsellBannerAd();
//   //   } else {
//   //     setState(() {});
//   //   }
//   // }

//   // showTapsellBannerAd() {
//   //   TapsellPlus.instance
//   //       .requestStandardBannerAd(
//   //           '62f95d2318fa666ca396104c', TapsellPlusBannerType.BANNER_320x50)
//   //       .then((responseId) {
//   //     responsebanner = responseId;
//   //     print('-------> Tapsell Banner Loaded');
//   //     isBannerAdLoaded = true;
//   //     setState(() {});
//   //     TapsellPlus.instance
//   //         .showStandardBannerAd(
//   //             responsebanner,
//   //             TapsellPlusHorizontalGravity.BOTTOM,
//   //             TapsellPlusVerticalGravity.CENTER,
//   //             margin: const EdgeInsets.only(top: 100),
//   //             onOpened: (map) {})
//   //         .catchError((error) {
//   //       print('-------> Eror with load Tapsell Banner');
//   //       responsebanner = '';
//   //     });

//   //     // SAVE the responseId
//   //   }).catchError((error) {
//   //     // Error when requesting for an ad
//   //     print('-------> Eror with load Tapsell Banner');
//   //     responsebanner = '';
//   //   });
//   // }

//   // showRewardedAd() async {
//   //   // if (await Appodeal.isLoaded(Appodeal.REWARDED_VIDEO)) {
//   //   isRewardedAdLoaded = await Appodeal.show(Appodeal.REWARDED_VIDEO);
//   //   if (isRewardedAdLoaded) {
//   //     controller.pause();
//   //   } else {
//   //     print('------------------->error');
//   //     showintertisailAd();
//   //   }

//   //   Appodeal.setRewardedVideoCallbacks(onRewardedVideoFinished: (d, s) {
//   //     controller.play();
//   //     isRewardedAdLoaded = true;
//   //   }, onRewardedVideoClosed: (t) {
//   //     controller.play();
//   //     isRewardedAdLoaded = true;
//   //   });
//   // }

//   // showintertisailAd() async {
//   //   isInterstitialAdLoaded = await Appodeal.show(Appodeal.INTERSTITIAL);
//   //   if (isInterstitialAdLoaded) {
//   //     controller.pause();
//   //   } else {
//   //     print('------------------->error');
//   //     // requestShowTapsellRewarded();
//   //   }

//   //   Appodeal.setInterstitialCallbacks(
//   //     onInterstitialShown: () {
//   //       controller.pause();
//   //     },
//   //   );
//   // }

//   createRewardedAd() async {
//     print('rewarded Ad start to load ----------------------------------');
//     // showRewardedAd();
//   }

//   // requestShowTapsellRewarded() {
//   //   TapsellPlus.instance
//   //       .requestRewardedVideoAd('62f957c3f06038717dd09d12')
//   //       .then((responseId) {
//   //     responserewarded = responseId;
//   //     if (responserewarded.length > 1) {
//   //       TapsellPlus.instance.showRewardedVideoAd(responserewarded,
//   //           onOpened: (map) {
//   //         controller.pause();
//   //         // Ad opened
//   //       }, onError: (map) {
//   //         loadAdFullSceeen = true;
//   //         // Ad had error - map contains `error_message`
//   //       }, onRewarded: (map) {
//   //         loadAdFullSceeen = true;
//   //         // Ad shown completely
//   //       }, onClosed: (map) {
//   //         controller.play();
//   //         loadAdFullSceeen = true;
//   //       });
//   //     }
//   //     // SAVE the responseId
//   //   }, onError: (error) {
//   //     print('Error with load rewarded ad $error');

//   //     showTapsellIntersttial();
//   //   });
//   // }

//   // showTapsellIntersttial() {
//   //   TapsellPlus.instance.requestInterstitialAd('62fbd878f06038717dd09e49').then(
//   //       (response) {
//   //     responseInterstitial = response;
//   //     TapsellPlus.instance.showInterstitialAd(responseInterstitial,
//   //         onOpened: (map) {
//   //       controller.pause();
//   //       loadAdFullSceeen = true;
//   //       // Ad opened
//   //     }, onError: (map) {
//   //       // Ad had error - map contains `error_message`
//   //       loadAdFullSceeen = true;
//   //     }, onClosed: (map) {
//   //       // Ad shown completely
//   //       loadAdFullSceeen = true;
//   //       controller.play();
//   //     });

//   //     // SAVE the responseId
//   //   }, onError: (error) {
//   //     print('Error with load interstitial ad $error');
//   //   });
//   // }

//   @override
//   void dispose() {
//     try {
//       // TapsellPlus.instance.hideStandardBanner();
//       // Appodeal.hide(AppodealAdType.BannerBottom); //AppodealAdType.MREC

//       // TapsellPlus.instance.destroyStandardBanner(responsebanner);
//     } catch (e) {
//       print('error with hide tapsell banner$e');
//     }

//     controller.removeListener(() {});
//     controller.dispose();

//     changeStatusBarColor(false);
//     // _mybannerAd?.dispose();
//     // _myRewardedAd?.dispose();

//     super.dispose();
//   }

//   void chnageVideoStater(data) {
//     map_data = data;
//     videoLoader(true);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               flex: 3,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           isControllerInit
//                               ? Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child:
//                                       (PodVideoPlayer(controller: controller)),
//                                 )
//                               : Container(),
//                           Directionality(
//                             textDirection: TextDirection.ltr,
//                             child: ListTile(
//                               title: MyText(
//                                 txt: map_data['title'] +
//                                     ' • ' +
//                                     map_data['subject'],
//                                 color: Colors.white,
//                                 textAlign: TextAlign.right,
//                                 size: 20,
//                               ),
//                               subtitle: MyText(
//                                 txt: map_data['sections'] == 1
//                                     ? 'تک قسمتی'
//                                     : 'تعداد قسمت ها: ${map_data['sections']}',
//                                 color: Colors.white,
//                                 textAlign: TextAlign.right,
//                                 size: 12,
//                               ),
//                               leading: const Icon(Icons.arrow_drop_down_rounded,
//                                   size: 40.0, color: Colors.white),
//                               onTap: () {},
//                             ),
//                           ),
//                           const Divider(
//                             color: Colors.white10,
//                           ),
//                           SizedBox(
//                             height: 70.0,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Column(
//                                   children: [
//                                     Expanded(
//                                         child: IconButton(
//                                             onPressed: () {
//                                               MySnackBar('به زودی',
//                                                   'این قابلیت به زودی ارایه خواهد شد');
//                                             },
//                                             icon: const Icon(
//                                               Icons.favorite,
//                                               color: Colors.white,
//                                             ))),
//                                     const Expanded(
//                                       child: MyText(
//                                         txt: 'علاقه مندی',
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     Expanded(
//                                       child: IconButton(
//                                         onPressed: () {
//                                           MySnackBar('به زودی',
//                                               'این قابلیت به زودی ارایه خواهد شد');
//                                         },
//                                         icon: const Icon(
//                                           Icons.share,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     const Expanded(
//                                       child: MyText(
//                                         txt: 'اشتراک گذاری',
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     Expanded(
//                                         child: IconButton(
//                                             onPressed: () {
//                                               MySnackBar('به زودی',
//                                                   'این قابلیت به زودی ارایه خواهد شد');
//                                             },
//                                             icon: const Icon(
//                                               Icons.comment,
//                                               color: Colors.white,
//                                             ))),
//                                     const Expanded(
//                                       child: MyText(
//                                         txt: 'نظر دادن',
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Divider(
//                             color: Colors.white10,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: SelectionArea(
//                               child: MyText(
//                                 textAlign: TextAlign.right,
//                                 txt: map_data['desc'],
//                               ),
//                             ),
//                           ),
//                           const Divider(
//                             color: Colors.white10,
//                           ),
//                           (MediaQuery.of(context).size.width <
//                                   MediaQuery.of(context).size.height)
//                               ? SectionCreator(
//                                   map_data: map_data,
//                                   changeVideo: chnageVideoStater,
//                                   iswided: false,
//                                   secdata: secdata,
//                                 )
//                               : Container()
//                         ],
//                       ),
//                     ),
//                     isBannerAdLoaded
//                         ? Container(
//                             // alignment: Alignment.center,
//                             // // width: _mybannerAd?.size.width.toDouble(),
//                             // height: 60.0,
//                             // // child: AdWidget(ad: _mybannerAd!),

//                             )
//                         : Container(),
//                   ],
//                 ),
//               ),
//             ),
//             (int.parse(widget.map_data['sections']) <= 1)
//                 ? Container()
//                 : (MediaQuery.of(context).size.width >=
//                         MediaQuery.of(context).size.height)
//                     ? Expanded(
//                         child: SectionCreator(
//                           map_data: map_data,
//                           changeVideo: chnageVideoStater,
//                           iswided: true,
//                           secdata: secdata,
//                         ),
//                       )
//                     : Container()
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SectionCreator extends StatefulWidget {
//   SectionCreator(
//       {super.key,
//       required this.map_data,
//       required this.changeVideo,
//       required this.iswided,
//       required this.secdata});

//   final Map map_data;
//   final Function(Map itemData) changeVideo;

//   final bool iswided;
//   List secdata;

//   @override
//   State<SectionCreator> createState() => _SectionCreatorState();
// }

// class _SectionCreatorState extends State<SectionCreator> {
//   @override
//   void initState() {
//     super.initState();

//     DataGetter dataGetter = DataGetter();
//     dataGetter.getData(widget.map_data['uniqu_id']).then((response) {
//       widget.secdata = jsonDecode(response.data);

//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (int.parse(widget.map_data['sections']) <= 1) {
//       return Container();
//     }
//     if (widget.secdata.isEmpty) {
//       return Center(
//         child: Column(
//           children: const [
//             CircularProgressIndicator(),
//             SizedBox(
//               height: 10.0,
//             ),
//             MyText(
//               txt: 'درحال بارگزاری قسمت ها',
//             ),
//           ],
//         ),
//       );
//     } else {
//       return Directionality(
//         textDirection: TextDirection.rtl,
//         child: GridView(
//             shrinkWrap: true,
//             physics:
//                 const BouncingScrollPhysics(), // if you want IOS bouncing effect, otherwise remove this line
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: widget.iswided ? 1 : 2,
//                 mainAxisExtent: 160), //change the number as you want
//             children: [
//               for (var i = 0; i < widget.secdata.length; i++)
//                 Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10.0),
//                       child: Container(
//                         height: 100,
//                         color: Colors.white.withAlpha(10),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () {
//                                   widget.changeVideo(widget.secdata[i]);
//                                 },
//                                 child: Stack(
//                                   fit: StackFit.expand,
//                                   children: [
//                                     CachedNetworkImage(
//                                       imageUrl: widget.secdata[i]['pic'],
//                                       fit: BoxFit.cover,
//                                     ),
//                                     Center(
//                                         child: PlayButton(
//                                       onClick: (data) {},
//                                       mapData: widget.secdata[i],
//                                     )),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: MyText(
//                                   txt: widget.secdata[i]['title'] +
//                                       '\n' +
//                                       '•' +
//                                       widget.secdata[i]['subject']),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ))
//             ]),
//       );
//     }
//   }
// }
