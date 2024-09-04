import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    this.text,
    this.isFilledColor = true,
    this.icon,
    this.color,
    this.textColor,
    this.loading = false,
  });

  final Function()? onPressed;
  final String? text;
  final bool isFilledColor;
  final IconData? icon;
  final Color? color;
  final bool loading;

  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: !isFilledColor
            ? BorderSide(
                width: 2,
                color: color ?? Colors.deepPurple,
                style: BorderStyle.solid,
              )
            : null,

        elevation: 0.5,
        shadowColor: Colors.black26,
        // full width
        minimumSize: const Size(double.infinity, 50),
        // foregroundColor: Colors.white,
        backgroundColor:
            (isFilledColor) ? color ?? Colors.deepPurple : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
      ),
      onPressed: loading == false ? onPressed : () {},
      child: onPressed != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading == false)
                  MyText(
                    txt: text ?? "",
                    fontWeight: FontWeight.bold,
                    color: isFilledColor
                        ? textColor ?? Colors.white
                        : textColor ?? (textColor ?? Colors.deepPurple),
                    // color: Colors.black,
                    size: 17 / 1.618,
                  ),
                if (loading == false) const Gap(10),
                if (loading == false)
                  icon != null
                      ? Icon(
                          icon,
                          color: isFilledColor
                              ? Colors.white
                              : color ?? Colors.deepPurple,
                        )
                      : const SizedBox(),
                if (loading == true)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
              ],
            )
          : const SizedBox(),
    );
  }
}
