import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/widgets/mytext.dart';
import '../../../../data/model/home_catagory_model.dart';

class CatagoryHomeView extends StatelessWidget {
  const CatagoryHomeView({
    super.key,
    required this.homeCatagoryItem,
  });

  final HomeCatagoryItemModel homeCatagoryItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.hexToColor(homeCatagoryItem.viewColor!)
          .withAlpha(int.parse(homeCatagoryItem.colorAlpha ?? "255")),
      width: double.tryParse(homeCatagoryItem.viewWidth!)!,
      height: double.tryParse(homeCatagoryItem.viewHeight!)!,
      child: Column(
        children: [
          Row(
            children: [
              const Gap(15),
              MyText(
                txt: homeCatagoryItem.title!,
                color: Theme.of(context).primaryTextTheme.bodyMedium!.color,
                fontWeight: FontWeight.bold,
                size: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: homeCatagoryItem.data?.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Constants.openHomeItem(homeCatagoryItem, index,
                          homeCatagoryItem.data?[index].thumbnail1x ?? "");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 0.4,
                              style: BorderStyle.solid)),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: Constants.imageFiller(
                              homeCatagoryItem.data?[index].thumbnail1x ?? '',
                            ),
                            width: 30,
                          ),
                          const Gap(5),
                          MyText(txt: homeCatagoryItem.data![index].title!),
                        ],
                      )),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
