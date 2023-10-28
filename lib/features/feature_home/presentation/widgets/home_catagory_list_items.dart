import 'package:flutter/material.dart';

import '../../data/model/home_catagory_item_model.dart';
import '../../data/model/home_catagory_model.dart';
import '../controller/home_page_controller.dart';

class HomeCatagoryListItems extends StatelessWidget {
  const HomeCatagoryListItems(
      {super.key, required this.homeCatagory, required this.controller});

  final HomeCatagory homeCatagory;
  final HomePageController controller;

  // get home catagory data
  HomeCatagagoryItemModel getHomeCatagoryItemData(
      String searchTerm, List<HomeCatagagoryItemModel> list) {
    for (HomeCatagagoryItemModel map in list) {
      if (map.title!.contains(searchTerm)) {
        return map;
      }
    }
    return HomeCatagagoryItemModel();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        // itemCount:
        //     getHomeCatagoryItemData(homeCatagory.title!, controller.homeData)
        //         .data
        //         ?.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (context, index) {
          return null;
        
          // HomeCatagagoryItemModel i =
          //     getHomeCatagoryItemData(homeCatagory.title!, controller.homeData);
          // SearchVideo item = i.data![index];
          // return GestureDetector(
          //   onTap: () async {
          //     await Get.to(() => DetailPage(vid_tag: item.tag!),
          //         arguments: item.tag!);
          //     final homePageController = Get.find<HomePageController>();
          //     homePageController.returnScreen();
          //   },
          //   child: SizedBox(
          //     width: 120,
          //     child: Column(
          //       children: [
          //         Container(
          //           width: 120,
          //           height: 180,
          //           margin: const EdgeInsets.symmetric(horizontal: 10.0),
          //           child: ClipRRect(
          //             borderRadius: BorderRadius.circular(10.0),
          //             child: CachedNetworkImage(
          //               imageUrl: Constants.imageFiller(item.thumbnail1x!),
          //               fit: BoxFit.cover,
          //               httpHeaders: const {
          //                 'Referer': 'https://www.cinimo.ir/'
          //               },
          //               // handle error
          //               errorWidget: (context, url, error) =>
          //                   const Icon(Icons.error),
          //               placeholder: (context, url) => Shimmer.fromColors(
          //                 baseColor: Colors.white10,
          //                 highlightColor: Colors.black12,
          //                 child: Container(
          //                   color: Colors.grey[300],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         const SizedBox(height: 5.0),
          //         MyText(
          //           txt: item.title!,
          //           color: Theme.of(context).primaryTextTheme.bodyMedium!.color,
          //           fontWeight: FontWeight.normal,
          //           maxLine: 2,
          //           size: 12.0,
          //           overflow: TextOverflow.ellipsis,
          //           textAlign: TextAlign.center,
          //         ),
          //       ],
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}
