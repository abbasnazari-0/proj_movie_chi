import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinput/pinput.dart';
import 'package:movie_chi/config/text_theme.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';

import '../../../../core/widgets/mytext.dart';
import '../../../feature_search/presentation/controller/search_page_controller.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({Key? key}) : super(key: key);

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final searchController = Get.find<SearchPageController>();

  onChange() {
    // if (searchController.controller.text.isEmpty) return;
    searchController.onstartLoadSearch(true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).primaryColor,
      ),
      width: size.width,
      child: TypeAheadField(
        suggestionsBoxController: searchController.suggestionsBoxController,
        textFieldConfiguration: TextFieldConfiguration(
          onTapOutside: (event) {
            searchController.onSearchBoxFocusing(false);
            searchController.suggestionsBoxController.close();
          },
          controller: searchController.controller,
          onSubmitted: (value) {
            List history = GetStorageData.getData("hisstory") ?? [];
            history.add(searchController.controller.text);
            GetStorageData.writeData("hisstory", history);
            onChange();
          },
          onTap: () {
            searchController.onSearchBoxFocusing(true);
            try {
              if (searchController.controller.selection ==
                  TextSelection.fromPosition(TextPosition(
                      offset: searchController.controller.text.length - 1))) {
                setState(() {
                  searchController.controller.selection =
                      TextSelection.fromPosition(TextPosition(
                          offset: searchController.controller.text.length));
                });
              }
            } catch (e) {
              if (kDebugMode) {
                debugPrint(e.toString());
              }
            }
            if (searchController.controller.text.isEmpty) {
              searchController.suggestionsBoxController.open();
              searchController.getSearchHisotry();
            } else {
              searchController.suggestionsBoxController.suggestionsBox?.close();
            }
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              searchController.onSearchBoxFocusing(true);

              searchController.suggestionsBoxController.suggestionsBox?.close();
            } else {
              searchController.onSearchBoxFocusing(false);
              searchController.suggestionsBoxController.suggestionsBox?.open();
            }
            // onChange();
          },
          style: faTextTheme(context),
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: GetBuilder<SearchPageController>(
                builder: (controller) => controller.searchFouceMode == true &&
                        controller.controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          // clear search Box
                          controller.controller.text = "";
                          onChange();
                        },
                      )
                    : const SizedBox(),
              ),
              prefixIcon: IconButton(
                onPressed: () {
                  onChange();
                },
                icon: Icon(Iconsax.search_normal4,
                    color: Theme.of(context).primaryIconTheme.color),
              ),
              hintText: '  جستجو نمایید',
              hintStyle: faTextTheme(context)),
        ),
        itemBuilder: (BuildContext context, itemData) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListTile(
              leading: const Icon(Icons.history),
              title: MyText(txt: itemData.toString()),
            ),
          );
        },
        onSuggestionSelected: (Object? suggestion) {
          if (searchController.suggestionList.isNotEmpty) {
            if (suggestion == "حذف تاریخچه") {
              searchController.removeSearchHisotry(context);
              return;
            }
          }
          searchController.controller.setText(suggestion.toString());
          onChange();
        },
        noItemsFoundBuilder: (context) {
          return const SizedBox();
        },
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius: BorderRadius.circular(20),
            elevation: 10,
            constraints: const BoxConstraints.tightForFinite(height: 200)),
        suggestionsCallback: (String pattern) async {
          if (pattern.isEmpty) {
            return searchController.suggestionList;
          } else {
            return [];
          }
        },
      ),
    );
  }
}
