import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ShareItemCirecule extends StatelessWidget {
  const ShareItemCirecule({
    Key? key,
    required this.messangerName,
    this.onTap,
  }) : super(key: key);

  final String messangerName;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          // color: Theme.of(context).accentColor,
          border: Border.all(
            color: Theme.of(context).textTheme.bodyMedium!.color!.withAlpha(20),
          ),
        ),
        padding: const EdgeInsets.all(3),
        height: 30,
        width: 30,
        child: Lottie.asset(
          'assets/lotties/$messangerName.json',
          height: 30,
          width: 30,
          fit: BoxFit.cover,
        ),
        // svg of whatsapp
      ),
    );
  }
}
