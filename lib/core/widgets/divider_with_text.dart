import 'package:flutter/material.dart';

import 'package:movie_chi/core/widgets/mytext.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({
    Key? key,
    required this.horizontalPadding,
    required this.text,
    this.divierColor = Colors.grey,
  }) : super(key: key);
  final double horizontalPadding;
  final String text;
  final Color divierColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: divierColor,
            ),
          ),
          const SizedBox(width: 20),
          MyText(txt: text),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 1,
              color: divierColor,
            ),
          ),
        ],
      ),
    );
  }
}
