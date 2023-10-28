import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/images/icon.png',
                height: 30,
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            MyText(
              txt: 'مووی چی!',
              color: Theme.of(context).primaryIconTheme.color,
            ),
            const Spacer(),
            IconButton(
                onPressed: () {}, icon: const Icon(Iconsax.sms_notification4))
          ],
        ),
      ),
    );
  }
}
