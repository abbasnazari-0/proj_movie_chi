import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_catagory/data/data_source/remote/catagory_params.dart';
import 'package:movie_chi/features/feature_catagory/data/data_source/remote/dataGettercatagory.dart';

class CatagoryShow extends StatefulWidget {
  const CatagoryShow({Key? key, required this.mData}) : super(key: key);
  final Map mData;

  @override
  State<CatagoryShow> createState() => _CatagoryShowState();
}

class _CatagoryShowState extends State<CatagoryShow> {
  List data = [];
  int itemCount = 25;
  void getData() async {
    DataGetterCatagory dataGetterCatagory = DataGetterCatagory();
    CatagoryParams catagoryParams =
        CatagoryParams(itemCount, widget.mData['tag']);
    dataGetterCatagory.getData(catagoryParams).then((response) {
      data = jsonDecode(response.data);

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('state created');
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Get.back();
            },
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: MyText(txt: widget.mData['title']),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: data.isNotEmpty
              ? Column(
                  children: [
                    /*
                    Bloc<CatagoryBloc,CatagoryState>(
                      create: (context,state) => CatagoryBloc(locator()),
                      child: Text('uhij'),
                    ),*/

                    Expanded(
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent: MediaQuery.of(context)
                                            .size
                                            .height *
                                        0.4,
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width ~/
                                            150),
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map mapData = data[index];
                              return GestureDetector(
                                onTap: () {
                                  // Get.to(() => DetailPage(
                                  //       map_data: mapData,
                                  //     ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      height: 250,
                                      color: Colors.white,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          CachedNetworkImage(
                                            colorBlendMode: BlendMode.srcOver,
                                            color: Colors.black.withAlpha(50),
                                            imageUrl: mapData['pic'],
                                            fit: BoxFit.fitHeight,
                                            // fix cors  er
                                            httpHeaders: const {
                                              'Referer':
                                                  'https://www.cinimo.ir/'
                                            },
                                            // handle error
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                color:
                                                    Colors.black.withAlpha(150),
                                                child: MyText(
                                                  txt: mapData['title'],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }))
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
