// import 'package:aramgah_ir/core/utils/constanse.dart';
// import 'package:aramgah_ir/core/widgets/fa_text.dart';
// import 'package:aramgah_ir/features/feature_auth/presentation/widgets/number_entring_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../../core/widgets/title_with_logo_widget.dart';
// import '../../controllers/auth_controller.dart';

// class PageNumberConfirmation extends StatefulWidget {
//   const PageNumberConfirmation({super.key, required this.pageController});
//   final PageController pageController;

//   @override
//   State<PageNumberConfirmation> createState() => _PageNumberConfirmationState();
// }

// class _PageNumberConfirmationState extends State<PageNumberConfirmation> {
//   final authControlle = Get.find<AuthController>();

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 30.0,
//           ),

//           const Spacer(),

//           const TitleLogoWidget(),

//           const Spacer(),

//           //Number input box in  number entring widget and locate  in widget direcotry
//           NumberEntringWidget(
//             textEditingController: authControlle.textEditingController,
//           ),

//           const Spacer(),

//           //submit button
//           GestureDetector(
//             onTap: () {
//               authControlle.sendCode(widget.pageController);
//             },
//             child: Container(
//               width: width,
//               height: 60,
//               decoration: BoxDecoration(
//                 gradient: gradiantTheme,
//                 borderRadius: BorderRadius.circular(80),
//               ),
//               child: Center(
//                 child: FaText(
//                   text: 'عضویت',
//                   color: Theme.of(context).textTheme.displayMedium!.color,
//                 ),
//               ),
//             ),
//           ),
//           const Spacer(),
//         ],
//       ),
//     );
//   }
// }
