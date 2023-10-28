import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_critism/presentation/pages/criticism_page.dart';

class MyFloatingActionButton extends StatelessWidget {
  const MyFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        width: 190.0,
        height: 50.0,
        color: Theme.of(context).colorScheme.secondary,
        child: GestureDetector(
          onTap: () {
            Get.to(() => const CriticismPage());
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MyText(
                txt: 'درخواست فیلم و انتقادات',
              ),
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
