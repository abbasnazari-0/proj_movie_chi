import 'package:flutter/material.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 100,
          ),
          MyText(txt: "صفحه جستجو", size: 16, fontWeight: FontWeight.bold),
          MyText(txt: "لطفا جستجو کنید", size: 12, fontWeight: FontWeight.w200),
        ],
      ),
    );
  }
}
