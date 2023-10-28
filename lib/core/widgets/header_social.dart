import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/constants.dart';
import '../utils/lauch_url.dart';

class SocialHeader extends StatelessWidget {
  const SocialHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Iconsax.instagram,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          onPressed: () {
            mlaunchUrl((Constants.instagramUrl));
            // homePageController.showSearchDialog();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.telegram_rounded,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          onPressed: () {
            mlaunchUrl((Constants.telegramUrl));
            // homePageController.showSearchDialog();
          },
        ),
      ],
    );
  }
}
