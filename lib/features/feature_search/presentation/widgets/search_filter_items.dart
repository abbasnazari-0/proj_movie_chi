import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/features/feature_search/presentation/controller/home_searchbar_controller.dart';

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
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [],
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [],
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
