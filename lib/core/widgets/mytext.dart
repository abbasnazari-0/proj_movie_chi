import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText(
      {Key? key,
      this.txt = '',
      this.color,
      this.textAlign = TextAlign.justify,
      this.size = 15,
      this.fontWeight,
      this.maxLine,
      this.overflow,
      this.length})
      : super(key: key);
  final String txt;
  final Color? color;
  final TextAlign textAlign;
  final double size;
  final FontWeight? fontWeight;
  final int? maxLine;
  final TextOverflow? overflow;
  final int? length;

  overFlosLenth(txt, length) {
    if (length == null) return txt;
    if (txt.length > length) {
      return txt.substring(0, length) + '...';
    } else {
      return txt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      overFlosLenth(txt, length),
      style: TextStyle(
          fontFamily: 'vazir',
          color: color ?? Theme.of(context).primaryTextTheme.bodyMedium!.color,
          fontSize: size,
          fontWeight: fontWeight),
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: overflow,
    );
  }
}
