import 'package:flutter/material.dart';

import '../../../../core/widgets/mytext.dart';

class HomeHeaderItem extends StatelessWidget {
  const HomeHeaderItem({
    Key? key,
    this.onPresses,
    this.title,
    required this.icon,
  }) : super(key: key);

  final Function()? onPresses;
  final String? title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPresses,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: 110,
        child: Card(
          elevation: 1,
          borderOnForeground: false,
          shadowColor: Colors.white10,
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lottie.asset("assets/lotties/$jsonFile",
                //     height: 60, fit: BoxFit.fitWidth, width: 60),

                Icon(icon,
                    size: 40, color: Theme.of(context).colorScheme.secondary),
                const Spacer(flex: 5),
                MyText(
                  txt: title ?? '',
                  size: 14,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
