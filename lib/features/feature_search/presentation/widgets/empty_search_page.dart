import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class SearchEmptyScreen extends StatelessWidget {
  const SearchEmptyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child:
              Center(child: LottieBuilder.asset('assets/lotties/empty.json')),
        ),
        const MyText(
          txt: 'متاسفانه هیچ فیلمی یافت نشد',
        ),
        const Spacer(),
      ],
    );
  }
}
