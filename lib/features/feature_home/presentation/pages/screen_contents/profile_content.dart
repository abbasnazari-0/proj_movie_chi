import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_chi/config/text_theme.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/profile_app_bar.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  TextEditingController numberController = TextEditingController();
  PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
    // PageController pcontroller = PageController();

    // pcontroller.jumpToPage(1);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const ProfileAppBar(),
        Expanded(
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              //0 =============================== UserSignup
              if (GetStorageData.getData('user_status') == 1)
                //User SignUp
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const MyText(
                        txt: 'ثبت کد تایید',
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        color: Colors.white10,
                        height: 1,
                        thickness: 0.4,
                        indent: width * 0.10,
                        endIndent: width * 0.10,
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Image.asset(
                        Constants.iconSrc,
                        width: width * 0.30,
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              labelText: 'شماره تماس',
                              labelStyle: faTextTheme(context).copyWith(),
                              alignLabelWithHint: true),
                          style: faTextTheme(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          child: const MyText(
                            txt: 'ورود و ثبت نام',
                          ))
                    ],
                  ),
                ),
              //1 ================================ User signin

              if (GetStorageData.getData('user_status') == 0 ||
                  GetStorageData.getData('user_status') == null)
                //User SignUp
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const MyText(
                        txt: 'ثبت شماره همراه',
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        color: Colors.white10,
                        height: 1,
                        thickness: 0.4,
                        indent: width * 0.10,
                        endIndent: width * 0.10,
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Image.asset(
                        Constants.iconSrc,
                        width: width * 0.30,
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: numberController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              labelText: 'شماره تماس',
                              labelStyle: faTextTheme(context).copyWith(),
                              alignLabelWithHint: true),
                          style: faTextTheme(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (numberController.text
                                .isValidIranianMobileNumber()) {
                              GetStorageData.writeData('user_status', 1);
                              setState(() {});
                            } else {
                              Fluttertoast.showToast(
                                msg: "شماره همراه نامعتبر",
                              );
                            }
                          },
                          child: const MyText(
                            txt: 'ورود و ثبت نام',
                          ))
                    ],
                  ),
                )
              //2 ============================= User rigrestred
              else if (GetStorageData.getData('user_status') == 2)
                //User registred
                Column(
                  children: [
                    CircleAvatar(
                      minRadius: (height + width) / 2 * 0.10,
                      foregroundImage: const CachedNetworkImageProvider(
                        'https://th.bing.com/th/id/R.5d2640166fb9248ee7ae20cbc19a9141?rik=QcfC8%2ft8rnv%2foQ&pid=ImgRaw&r=0',
                      ),
                    ),
                  ],
                )
              else
                Container()
            ],
          ),
        ),
      ],
    );
  }
}
