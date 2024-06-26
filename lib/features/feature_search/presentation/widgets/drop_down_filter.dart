// // import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:movie_chi/core/widgets/mytext.dart';

// class DropDownFilter extends StatefulWidget {
//   const DropDownFilter(
//       {super.key, required this.list, required this.title, this.onSelected});

//   final List<String> list;
//   final String title;
//   final Function(String? value)? onSelected;

//   @override
//   State<DropDownFilter> createState() => _DropDownFilterState();
// }

// class _DropDownFilterState extends State<DropDownFilter> {
//   bool isItemSelected = false;
//   @override
//   void initState() {
//     // widget.list.insert(0, widget.title);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Add "حذف این فیلتر" to the first item in the list

//     // return DropdownButtonFormField2(
//     //     alignment: Alignment.center,
//     //     decoration: InputDecoration(
//     //       //Add isDense true and zero Padding.
//     //       //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
//     //       isDense: false,
//     //       contentPadding: EdgeInsets.zero,
//     //       fillColor: Theme.of(context).primaryTextTheme.bodyMedium!.color,
//     //       border: InputBorder.none,

//     //       //Add more decoration as you want here
//     //       //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
//     //       // prefixIcon: isItemSelected
//     //       //     ? IconButton(
//     //       //         icon: const Icon(Icons.close),
//     //       //         onPressed: () {
//     //       //           setState(() {
//     //       //             isItemSelected = false;
//     //       //           });
//     //       //           widget.onSelected!(null);
//     //       //         },
//     //       //       )
//     //       //     : null,
//     //     ),
//     //     dropdownDirection: DropdownDirection.right,
//     //     buttonDecoration: BoxDecoration(
//     //       color: Theme.of(context).primaryColor,
//     //       borderRadius: BorderRadius.circular(15),
//     //     ),
//     //     isExpanded: true,
//     //     hint: MyText(txt: widget.title),
//     //     icon: Icon(
//     //       Icons.arrow_drop_down,
//     //       color: Theme.of(context).primaryTextTheme.bodyMedium!.color,
//     //     ),
//     //     iconSize: 30,
//     //     buttonHeight: 60,
//     //     buttonPadding: const EdgeInsets.only(left: 20, right: 10),
//     //     dropdownDecoration: BoxDecoration(
//     //       color: Theme.of(context).primaryColor,
//     //       borderRadius: BorderRadius.circular(15),
//     //     ),
//     //     items: widget.list
//     //         .map((item) => DropdownMenuItem<String>(
//     //               value: item.toString(),
//     //               child: Directionality(
//     //                 textDirection: TextDirection.rtl,
//     //                 child: MyText(
//     //                   txt: item.toString(),
//     //                   textAlign: TextAlign.start,
//     //                 ),
//     //               ),
//     //             ))
//     //         .toList(),
//     //     // value: isItemSelected == false ? widget.title : null,
//     //     validator: (value) {
//     //       if (value == null) {
//     //         return widget.title;
//     //       }
//     //       return null;
//     //     },
//     //     onChanged: (String? d) {
//     //       widget.onSelected!(d);

//     //       isItemSelected = true;
//     //       setState(() {});
//     //     },
//     //     onSaved: (String? d) {
//     //       widget.onSelected!(d);
//     //       isItemSelected = true;
//     //       setState(() {});
//     // });
//   }
// }
