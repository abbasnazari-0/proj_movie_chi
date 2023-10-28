import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../config/text_theme.dart';
import '../controllers/artist_list_controller.dart';

class ArtistSearchBox extends StatelessWidget {
  ArtistSearchBox({
    Key? key,
    required this.size,
    required this.onSubmited,
    required this.onClosed,
    required this.onChanegd,
    required this.searchController,
  }) : super(key: key);

  final Size size;

  final Function(String? value) onSubmited;
  final Function onClosed;
  final artistController = Get.find<ArtistListController>();
  final Function onChanegd;
  final TextEditingController searchController;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).primaryColor,
        ),
        width: size.width,
        child: TextField(
          onTapOutside: (event) {},
          onSubmitted: (value) {
            // onChange();
            onSubmited(value);
          },
          controller: searchController,
          onTap: () {
            artistController.changeFocus(true);

            try {
              if (searchController.selection ==
                  TextSelection.fromPosition(
                      TextPosition(offset: searchController.text.length - 1))) {
                setState(() {
                  artistController.searchController.selection =
                      TextSelection.fromPosition(
                          TextPosition(offset: searchController.text.length));
                });
              }
            } catch (e) {
              if (kDebugMode) {
                debugPrint(e.toString());
              }
            }
          },
          onChanged: (value) {
            onChanegd();
            if (value.isNotEmpty) {
              artistController.changeFocus(true);
            } else {
              artistController.changeFocus(false);
            }
          },
          style: faTextTheme(context),
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon:
                  artistController.isFocused && searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            // clear search Box
                            searchController.text = "";
                            // onChange();
                            onClosed();
                          },
                        )
                      : const SizedBox(),
              prefixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Iconsax.search_normal4,
                    color: Theme.of(context).primaryIconTheme.color),
              ),
              hintText: '  جستجو نمایید',
              hintStyle: faTextTheme(context)),
        ),
      );
    });
  }
}
