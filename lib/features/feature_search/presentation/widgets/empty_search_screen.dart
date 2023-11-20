import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 100.sp,
          ),
          MyText(txt: "صفحه جستجو", size: 16.sp, fontWeight: FontWeight.bold),
          MyText(
              txt: "لطفا جستجو کنید", size: 12.sp, fontWeight: FontWeight.w200),
        ],
      ),
    );
  }
}
