import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

Widget catagoryWidget(List tagData) {
  return Row(
    children: [
      for (var i = 0; i < tagData.length; i++)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: MyText(
              txt: tagData[i].toString(),
              fontWeight: FontWeight.bold,
              color: Get.theme.textTheme.bodyMedium?.color?.withAlpha(150),
            ),
          ),
        ),
    ],
  );
}
