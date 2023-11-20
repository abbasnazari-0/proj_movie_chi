import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/features/feature_search/presentation/controller/home_searchbar_controller.dart';
import 'package:movie_chi/features/feature_search/presentation/widgets/drop_down_filter.dart';

class SearchFilterParent extends StatefulWidget {
  const SearchFilterParent({
    super.key,
  });

  @override
  State<SearchFilterParent> createState() => _SearchFilterParentState();
}

class _SearchFilterParentState extends State<SearchFilterParent> {
  final cont = Get.find<HomeSearchBarController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                SearchFilterWidget(
                    child: DropDownFilter(
                  list: cont.typeList,
                  title: "نوع",
                  onSelected: (value) {
                    if (value == null) return;
                    cont.typeSelected = value;
                  },
                )),
                const SizedBox(width: 10),
                SearchFilterWidget(
                    child: DropDownFilter(
                  list: cont.zhannerList,
                  title: "ژانر",
                  onSelected: (value) {
                    print(value);
                    // if (value == null) return;
                    cont.zhannerSelected = value!;
                  },
                )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                SearchFilterWidget(
                    child: DropDownFilter(
                  list: cont.imdbItems,
                  title: "امتیاز IMDB",
                  onSelected: (value) {
                    // if (value == null) return;
                    cont.imdbSelected = value!;
                  },
                )),
                const SizedBox(width: 10),
                SearchFilterWidget(
                    child: DropDownFilter(
                  list: cont.yearItems,
                  title: "سال ساخت",
                  onSelected: (value) {
                    if (value == null) return;
                    cont.yearSelected = value;
                  },
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SearchFilterWidget extends StatelessWidget {
  const SearchFilterWidget({super.key, required this.child, this.onPressed});
  final Widget child;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onPressed,
        child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white10),
            child: child),
      ),
    );
  }
}
