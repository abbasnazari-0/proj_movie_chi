import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
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

  onChange(bool isDebouncer) {
    // if (searchController.controller.text.isEmpty) return;
    searchController.onstartLoadSearch(true, isDebouncer: isDebouncer);
  }

  final Debouncer debouncer =
      Debouncer(delay: const Duration(milliseconds: 1000));

  var focusNode = FocusNode();
  @override
  void initState() {
    super.initState();

// or
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Hero(
      tag: 'search-widget',
      child: Container(
        // margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).primaryColor,
        ),
        width: size.width,
        child: TypeAheadField(
          suggestionsBoxController: searchController.suggestionsBoxController,
          textFieldConfiguration: TextFieldConfiguration(
            focusNode: focusNode,
            onTapOutside: (event) {
              searchController.onSearchBoxFocusing(false);
              searchController.suggestionsBoxController.close();
            },
            controller: searchController.controller,
            onSubmitted: (value) {
              List history = GetStorageData.getData("hisstory") ?? [];
              history.add(searchController.controller.text);
              GetStorageData.writeData("hisstory", history);
              onChange(false);
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
                searchController.suggestionsBoxController.suggestionsBox
                    ?.close();
              }
            },
            onChanged: (value) {
              debouncer.call(() {
                if (value.isNotEmpty) {
                  searchController.onSearchBoxFocusing(true);

                  searchController.suggestionsBoxController.suggestionsBox
                      ?.close();
                } else {
                  searchController.onSearchBoxFocusing(false);
                  searchController.suggestionsBoxController.suggestionsBox
                      ?.open();
                }
                onChange(true);
              });
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
                            onChange(false);
                          },
                        )
                      : const SizedBox(),
                ),
                prefixIcon: IconButton(
                  onPressed: () {},
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
            onChange(false);
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
      ),
    );
  }
}
