import 'package:flutter/material.dart';

import '../../../../core/widgets/mytext.dart';

class HeaderActionButtons extends StatelessWidget {
  const HeaderActionButtons({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);
  final String title;
  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary.withAlpha(200),
              Theme.of(context).colorScheme.secondary.withAlpha(50),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: width / 4 - 20,
        height: width / 4 - 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: 25),
            MyText(
              txt: title,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              size: 10,
            ),
          ],
        ),
      ),
    );
  }
}
