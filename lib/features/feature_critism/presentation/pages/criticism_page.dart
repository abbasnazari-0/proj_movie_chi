// import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_critism/data/data_source/remote/dataSenderCriticsm.dart';

class CriticismPage extends StatefulWidget {
  const CriticismPage({Key? key}) : super(key: key);

  @override
  State<CriticismPage> createState() => _CriticismPageState();
}

class _CriticismPageState extends State<CriticismPage> {
  int critcism_type = 0;
  TextEditingController critcism_text = TextEditingController();

  void postCritsimData() {
    if (critcism_text.text.isEmpty) {
      SnackBar('خطا', 'لطفا چیزی بنویسید');
      return;
    }

    SnackBar('صبر کنید...', 'لطفا صبر کنید...');
    DataSenderCritism datasender = DataSenderCritism();
    datasender.dataSender(critcism_text.text).then((response) {
      if (response.data.startsWith('success')) {
        SnackBar('تشکر از شما ',
            'با تشکر از شما ما در سدد توسعه بهترین اپلیکیشن از شما میابشیم');

        Get.close(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,
                color: Theme.of(context).primaryIconTheme.color),
            onPressed: () {
              Get.back();
            },
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const MyText(txt: 'نظرات و پیشنهادات '),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: MyText(
                    txt:
                        'لطفا انتقادات و پیشنهادات خود را از این قسمت اضافه نمایید \n در صورتیکه میخواهید درخواست اضافه کردن فیلم را داشته باشید هم میتوانید از گزینه درخواست فیلم فیلم مورد نظر را بنویسید تا بعد از بررسی در برنامه اضافه شود',
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                DropDown(critcism_text: critcism_text),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      postCritsimData();
                    },
                    child: const MyText(
                      txt: 'ثبت',
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropDown extends StatefulWidget {
  const DropDown({Key? key, required this.critcism_text}) : super(key: key);

  final TextEditingController critcism_text;

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  final List<String> genderItems = [
    'درخواست اضافه کردن فیلم',
    'انتقاد',
    'شکایت',
  ];

  String selectedValue = "نوع نظر";

  String fieldValue = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (selectedValue == "نوع نظر") {
      fieldValue = "لطفا ";
    } else if (selectedValue == "درخواست اضافه کردن فیلم") {
      fieldValue = "لطفا نام فیلم مورد نظر را";
    } else if (selectedValue == "انتقاد") {
      fieldValue = "لطفا انتقاد خود را ";
    } else if (selectedValue == "شکایت") {
      fieldValue = "لطفا شکایت خود را ";
    } else {}
    return Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // DropdownButtonFormField2(
                //   decoration: InputDecoration(
                //     //Add isDense true and zero Padding.
                //     //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                //     isDense: false,
                //     contentPadding: EdgeInsets.zero,
                //     fillColor:
                //         Theme.of(context).primaryTextTheme.bodyMedium!.color,
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //     //Add more decoration as you want here
                //     //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                //   ),
                //   isExpanded: true,
                //   hint: Text(
                //     'نوع نظر',
                //     style: TextStyle(
                //       fontSize: 14,
                //       fontFamily: 'vazir',
                //       color:
                //           Theme.of(context).primaryTextTheme.bodyMedium!.color,
                //     ),
                //   ),
                //   icon: Icon(
                //     Icons.arrow_drop_down,
                //     color: Theme.of(context).primaryTextTheme.bodyMedium!.color,
                //   ),
                //   iconSize: 30,
                //   buttonHeight: 60,
                //   buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                //   dropdownDecoration: BoxDecoration(
                //     color: Theme.of(context).primaryColor,
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   items: genderItems
                //       .map((item) => DropdownMenuItem<String>(
                //             value: item,
                //             child: Directionality(
                //               textDirection: TextDirection.rtl,
                //               child: Text(
                //                 item,
                //                 textAlign: TextAlign.right,
                //                 style: TextStyle(
                //                   color: Theme.of(context)
                //                       .primaryTextTheme
                //                       .bodyMedium!
                //                       .color,
                //                   fontSize: 14,
                //                   fontFamily: 'vazir',
                //                 ),
                //               ),
                //             ),
                //           ))
                //       .toList(),
                //   validator: (value) {
                //     if (value == null) {
                //       return 'نوع نظر';
                //     }
                //     return null;
                //   },
                //   onChanged: (value) {
                //     selectedValue = "$value";
                //     setState(() {});
                //   },
                //   onSaved: (value) {
                //     selectedValue = value.toString();
                //   },
                // ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: widget.critcism_text,
                  maxLines: null,
                  style: TextStyle(
                      fontSize: 14,
                      color:
                          Theme.of(context).primaryTextTheme.bodyMedium!.color,
                      fontFamily: 'vazir'),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    hintText: '$fieldValueوارد نمایید',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .primaryTextTheme
                            .bodyMedium!
                            .color,
                        fontFamily: 'vazir'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}

SnackbarController SnackBar(title, message) => Get.snackbar(
      '',
      '',
      titleText: MyText(txt: title, textAlign: TextAlign.center),
      messageText: MyText(txt: message, textAlign: TextAlign.center),
      duration: const Duration(seconds: 2),
    );
