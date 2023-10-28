// import 'package:aramgah_ir/core/resources/get_storage_data.dart';
// import 'package:aramgah_ir/core/utils/constanse.dart';
// import 'package:aramgah_ir/core/widgets/fa_text.dart';
// import 'package:aramgah_ir/core/widgets/title_with_logo_widget.dart';
// import 'package:aramgah_ir/features/feature_auth/presentation/widgets/code_confirmation_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../controllers/auth_controller.dart';

// class PageCodeConfirmation extends StatelessWidget {
//   PageCodeConfirmation({super.key, required this.pageController});

//   final PageController pageController;
//   final authControlle = Get.find<AuthController>();
//   String confirmCode = "";

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;

//     return SafeArea(
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 30.0,
//           ),
//           //app bar

//           const Spacer(),

//           const TitleLogoWidget(),

//           const Spacer(),

//           //Verfication code widget locate in widget direcotry
//           VerificationCodeWidget(),
//           const Spacer(),

//           GetBuilder<AuthController>(builder: (controller) {
//             return Visibility(
//               visible: controller.resendButtonVisible,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         authControlle.sendCode(pageController);
//                       },
//                       child: FaText(
//                         text: "ارسال مجدد کد تایید",
//                         color: Colors.black,
//                         size: 13.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10.0,
//                     ),
//                     FaText(
//                       text: "کد را دریافت نکردید؟",
//                       color: Colors.black,
//                       size: 10.sp,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//           const SizedBox(
//             height: 30.0,
//           ),
//           //Submit button
//           GestureDetector(
//             onTap: () {
//               if (authControlle.confirmCode.string.length == 4) {
//                 authControlle.checkOTPCode(
//                     GetSharedData.readData('phone_number'), context);
//               }
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
//                   text: 'تایید کد',
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
