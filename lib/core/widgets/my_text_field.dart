import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    this.textEditingController,
    this.label,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.textColor,
    this.size = 18 / 1.618,
    this.fontWeight = FontWeight.normal,
    this.suffixIcon,
    this.isPassword = false,
    this.enabled,
    this.onSuffixClicked,
    this.borderColor,
    this.text,
    this.minLine,
  });

  final TextEditingController? textEditingController;
  final String? label;
  final Function(String text)? onChanged;
  final Function()? onSuffixClicked;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final Color? textColor;
  final double? size;
  final FontWeight? fontWeight;
  final Widget? suffixIcon;
  final bool? isPassword;
  final bool? enabled;
  final Color? borderColor;
  final String? text;
  final int? minLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            MyText(
              txt: label ?? "",
              color: Colors.black38,
              fontWeight: FontWeight.w500,
              size: 18 / 1.618,
            )
          ],
        ),
        Directionality(
          textDirection:
              (isPassword ?? false) ? TextDirection.rtl : TextDirection.rtl,
          child: TextField(
            enabled: enabled ?? true,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType ?? TextInputType.text,
            controller: textEditingController,
            onChanged: onChanged,
            obscureText: isPassword ?? false,
            style: TextStyle(
                fontFamily: 'peyda',
                color: textColor ??
                    Theme.of(context).primaryTextTheme.bodyMedium!.color,
                fontSize: size,
                fontWeight: fontWeight),
            maxLines: minLine == null ? 1 : null,
            minLines: minLine,
            decoration: InputDecoration(
              labelText: text,
              labelStyle: TextStyle(
                  fontFamily: 'peyda',
                  color: textColor ??
                      Theme.of(context).primaryTextTheme.bodyMedium!.color,
                  fontSize: size,
                  fontWeight: fontWeight),
              // prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              prefixIcon: prefixIcon != null
                  ? InkWell(onTap: onSuffixClicked, child: Icon(prefixIcon))
                  : null,
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.deepPurple.withAlpha(100),
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              suffixIcon: suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.deepPurple.withAlpha(50),
                  // style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  strokeAlign: 2,
                  color: Colors.blue,
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              // labelText: 'Product Name',
            ),
          ),
        ),
      ],
    );
  }
}
