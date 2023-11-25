// // ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison

// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_meedu_videoplayer/meedu_player.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart' as iconsax;

// import 'package:movie_chi/core/utils/get_storage_data.dart';
// import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';
// import 'package:movie_chi/locator.dart';
// // import '../../../../core/ad/ad_controller.dart';
// import '../../../../core/utils/constants.dart';
// import '../../../../core/utils/database_helper.dart';
// import '../controller/video_player_controller.dart';
// import '../widgets/bottom_right_widget.dart';
// import '../widgets/header_widget.dart';
// import '../widgets/video_overly_widget.dart';

// // // create function to check all videos url and return 720 quality video if not exist return 480 quality video and other

// String getVideoUrl(Video video, {String? custom}) {
//   if (custom != null) {
//     return Constants.videoFiller(custom);
//   }
//   String url = "";
//   if (video.quality1080 != null) {
//     url = video.quality1080!;
//   } else if (video.quality720 != null) {
//     url = video.quality720!;
//   } else if (video.quality480 != null) {
//     url = video.quality480!;
//   } else if (video.quality360 != null) {
//     url = video.quality360!;
//   } else if (video.quality240 != null) {
//     url = video.quality240!;
//   }
//   return url;
// }

// class VideoPlayerScreen extends StatefulWidget {
//   const VideoPlayerScreen({super.key, this.isLocaled = false});

//   final bool isLocaled;
//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   final pageVideoPlayerController =
//       Get.put(PageVideoPlayerController(locator()));

//   // final adController = Get.find<AdController>();

//   // showAd() async {
//   //   await adController.adInitilzer?.loadInterstitial();
//   //   await adController.adInitilzer?.showRewarded();
//   // }

//   var playerCustomIcons = const CustomIcons(
//     play: Icon(iconsax.Iconsax.play),
//     pause: Icon(iconsax.Iconsax.pause),
//     fastForward: Icon(iconsax.Iconsax.forward_10_seconds4),
//     rewind: Icon(iconsax.Iconsax.backward_10_seconds4),

//     // videoFit: Icon(Iconsax.expand),
//     fullscreen: Icon(iconsax.Iconsax.d_rotate4),
//     minimize: Icon(iconsax.Iconsax.d_rotate4),
//     videoFit: Icon(iconsax.Iconsax.maximize_34),
//     pip: Icon(iconsax.Iconsax.screenmirroring4),
//     repeat: Icon(iconsax.Iconsax.repeat),
//   );

//   @override
//   void initState() {
//     super.initState();

//     pageVideoPlayerController.loadLastView();
//   }

//   DictionaryDataBaseHelper dbHelper = locator();

//   @override
//   void dispose() {
//     super.dispose();
//     pageVideoPlayerController.controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GetBuilder<PageVideoPlayerController>(builder: (controllerrr) {
//         return Stack(
//           fit: StackFit.expand,
//           children: [
//             AspectRatio(
//               aspectRatio: 9 / 16,
//               child: MeeduVideoPlayer(
//                 controller: pageVideoPlayerController.controller,
//                 customCaptionView: (context, controller, responsive, text) {
//                   return CustomCaption(string: text, responsive: responsive);
//                 },
//                 videoOverlay: (context, controller, responsive) {
//                   // add watermark in bottom righ
//                   return VideoOverlyWidget(responsive: responsive);
//                 },
//                 header: (context, controller, responsive) => HeaderWidget(
//                     pageVideoPlayerController: pageVideoPlayerController,
//                     responsive: responsive),
//                 customIcons: (responsive) {
//                   return playerCustomIcons;
//                 },
//                 // bottomRight: (context, controller, responsive) {
//                 //   return BottomRightWidget(
//                 //       pageVideoPlayerController: pageVideoPlayerController);
//                 // },
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

// class CustomCaption extends StatelessWidget {
//   const CustomCaption({
//     Key? key,
//     required this.string,
//     required this.responsive,
//   }) : super(key: key);
//   final String string;
//   final Responsive responsive;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
//           decoration: BoxDecoration(
//             color: string.isNotEmpty
//                 ? GetStorageData.getData("subtitleBackgroundColor_") ??
//                     Colors.black.withAlpha(180)
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Directionality(
//             textDirection: TextDirection.rtl,
//             child: Html(data: string, shrinkWrap: true, style: {
//               "html": Style(
//                   textAlign: TextAlign.center,
//                   color: GetStorageData.getData("subtitleColor_") ??
//                       Colors.white.withAlpha(180))
//             }),
//           ),
//         ),
//       ],
//     );
//   }
// }
