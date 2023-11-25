// import 'package:flutter/material.dart';
// import 'package:flutter_meedu_videoplayer/meedu_player.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../../../core/widgets/mytext.dart';
// import '../controller/video_player_controller.dart';
// import '../controller/video_player_view_controller.dart';

// class VideoOverlyWidget extends StatelessWidget {
//   VideoOverlyWidget({super.key, required this.responsive});
//   final Responsive responsive;

//   final pageVideoPlayerController = Get.find<PageVideoPlayerController>();
//   @override
//   Widget build(BuildContext context) {
//     return StatefulBuilder(builder: (context, setState) {
//       return GetBuilder<VideoPlayerViewController>(builder: (cont) {
//         return cont.showWaterMark
//             ? Stack(
//                 children: [
//                   Positioned(
//                     bottom: responsive.wp(5),
//                     right: responsive.wp(5),
//                     child: Container(
//                       padding: const EdgeInsets.all(5),
//                       child: Row(
//                         children: [
//                           const SizedBox(width: 10),
//                           Image.asset(
//                             'assets/images/icon.png',
//                             height: 20,
//                           ),
//                           const SizedBox(width: 10),
//                           const MyText(
//                             txt: 'مووی چی!؟',
//                             color: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: LinearProgressIndicator(
//                         value: pageVideoPlayerController
//                                     .controller.position.value.inSeconds >
//                                 0
//                             ? (pageVideoPlayerController
//                                     .controller.position.value.inSeconds
//                                     .toDouble() /
//                                 pageVideoPlayerController
//                                     .controller.duration.value.inSeconds
//                                     .toDouble())
//                             : 0,
//                         color: Colors.red,
//                         minHeight: 4.h,
//                       ))
//                 ],
//               )
//             : Container();
//       });
//     });
//   }
// }
