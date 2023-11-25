import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.flickr(
      size: 50,
      leftDotColor: Theme.of(context).colorScheme.secondary,
      rightDotColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
    ));
  }
}
