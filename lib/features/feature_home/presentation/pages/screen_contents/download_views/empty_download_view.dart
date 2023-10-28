import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/widgets/mytext.dart';

class EmptyDownloadPage extends StatelessWidget {
  const EmptyDownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Lottie.asset(
            "assets/lotties/empty.json",
            height: height * 0.5,
            width: width * 0.3,
          ),
          const MyText(
            txt: "فایل دانلودی پیدا نشد",
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
