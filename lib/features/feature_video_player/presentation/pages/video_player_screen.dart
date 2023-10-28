// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart' as mediaKit;
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:movie_chi/config/text_theme.dart';

// import '../../../../core/ad/ad_controller.dart';
// import '../../../../locator.dart';
// import '../controller/video_player_controller.dart';
// import 'feature_video_player.dart';

// class VideoPlayerPage extends StatefulWidget {
//   const VideoPlayerPage({
//     Key? key,
//     required this.isLocaled,
//   }) : super(key: key);
//   final bool isLocaled;

//   @override
//   State<VideoPlayerPage> createState() => _VideoPlayerPageState();
// }

// class _VideoPlayerPageState extends State<VideoPlayerPage> {
//   final pageVideoPlayerController =
//       Get.put(PageVideoPlayerController(locator()));
//   final adController = Get.find<AdController>();
//   bool isFullScreen = false;

//   late final player = Player();

//   late final controller = mediaKit.VideoController(player,
//       configuration: VideoControllerConfiguration(
//         enableHardwareAcceleration: true,
//       ));

//   @override
//   void initState() {
//     super.initState();
//     pageVideoPlayerController.baseVideo = Get.arguments["data"];
//     if (Get.arguments["path"] != null) {
//       pageVideoPlayerController.localPath = Get.arguments["path"];
//     }

//     player.open(Media(
//       Get.arguments['custom_link'] ??
//           getVideoUrl(pageVideoPlayerController.baseVideo!),
//     ));

//     player.stream.tracks.listen((event) {
//       List<VideoTrack> videos = event.video;
//       List<AudioTrack> audios = event.audio;
//       List<SubtitleTrack> subtitles = event.subtitle;
//       print("subtitle track : " + subtitles.toString());
//       print("video track : " + videos.toString());
//       print("audio track : " + audios.toString());
//     });

//     print(pageVideoPlayerController.baseVideo?.tagData);

//     initVideoPlayer();
//   }

//   initVideoPlayer() async {
//     await player.setSubtitleTrack(
//       SubtitleTrack.uri(
//         'https://api.cinimo.ir/Pirates.Of.The.Caribbean.The.Curse.Of.The.Black.Pearl.Farsi_Persian-WWW.MY-SUBS.CO.srt',
//         title: 'persian',
//         language: 'fa',
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     disposeVide();
//   }

//   disposeVide() async {
//     await player.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: mediaKit.Video(
//         controller: controller,
//         controls: MaterialVideoControls,
//         subtitleViewConfiguration: SubtitleViewConfiguration(
//           style: TextStyle(
//             height: 40,
//             fontSize: 40.0,
//             letterSpacing: 0.0,
//             wordSpacing: 0.0,
//             color: Colors.red,
//             fontWeight: FontWeight.normal,
//             backgroundColor: Color(0xaa000000),
//           ),
//           textAlign: TextAlign.center,
//           visible: true,
//           padding: EdgeInsets.all(5.0),
//         ),
//       ),
//     );
//   }
// }
