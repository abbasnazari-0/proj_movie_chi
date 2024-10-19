import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/params/check_device_status.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/loading_utils.dart';
import 'package:movie_chi/core/widgets/general_dialog.dart';
import 'package:movie_chi/core/widgets/my_button.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_login_screen/data/models/request_device_model.dart';
import 'package:movie_chi/features/feature_login_screen/domain/usecase/otp_usecase.dart';
import 'package:movie_chi/locator.dart';

class AddDeviceController {
  final OTPUseCase otpUseCase = locator();
  call() {
    Get.bottomSheet(build(), isScrollControlled: true);
  }

  String? token;

  LoadingUtils loadingUtils = LoadingUtils(Get.context!);
  onSubmit(String? token, String? tokenId) async {
    loadingUtils.startLoading();
    DataState dataState =
        await otpUseCase.submitDeviceStatus(CheckDeviceStatusParams(
      userTag: GetStorageData.getData("user_tag"),
      token: token ?? "",
      tokenID: tokenId ?? "",
    ));

    loadingUtils.stopLoading();
    if (dataState is DataSuccess) {
      Get.back();
      RequestDeviceModel requestDeviceModel = dataState.data;

      GeneralDialog.show(
          Get.context!, "", requestDeviceModel.message ?? "", "اتمام", () {});
    } else {
      Get.snackbar("خطا", "خطا در ثبت دستگاه");
    }
  }

  Widget buildScanner() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: Get.height,
      child: AiBarcodeScanner(
        onDispose: () {
          /// This is called when the barcode scanner is disposed.
          /// You can write your own logic here.
          debugPrint("Barcode scanner disposed!");
        },
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        // extendBodyBehindAppBar: false,
        // hideGalleryButton: true,
        // hideSheetTitle: true,
        // hideSheetDragHandler: true,
        onDetect: (BarcodeCapture capture) {
          /// The row string scanned barcode value
          final String? scannedValue = capture.barcodes.first.displayValue;
          token = (scannedValue) ?? "";
          debugPrint(token);
          if (token?.length == 10) Get.back();

          onSubmit(token, textEditingController.text);

          /// The `Uint8List` image is only available if `returnImage` is set to `true`.
          // final Uint8List? image = capture.image;

          // /// row data of the barcode
          // final Object? raw = capture.raw;

          // /// List of scanned barcodes if any
          // final List<Barcode> barcodes = capture.barcodes;
        },
        validator: (value) {
          if (value.barcodes.isEmpty) {
            return false;
          }
          if (!(value.barcodes.first.rawValue?.contains('flutter.dev') ??
              false)) {
            return false;
          }
          return true;
        },
      ),
    );
  }

  TextEditingController textEditingController = TextEditingController();

  Widget build() {
    return Container(
      height: Get.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(10),
      // margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const Gap(10),
          const MyText(
            txt: "افزودن دستگاه",
            size: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          const Gap(10),
          const MyText(
            txt: "لطفا کد مقابل دستگاه را اسکن کنید و یا بصورت دستی وارد کنید",
            size: 18,
            color: Colors.white,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.center,
          ),
          const Gap(10),
          TextField(
            textAlign: TextAlign.center,
            controller: textEditingController,
            maxLength: 4,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "کد دستگاه ۴ رقمی را وارد کنید",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),

          // MyTextField(
          //   label: "کد دستگاه",
          //   keyboardType: TextInputType.number,
          //   // prefixIcon: Icons.numbers_rounded,
          //   textEditingController: textEditingController,
          //   borderColor: Colors.white,
          //   // size: ,
          // ),
          const Gap(10),
          const Divider(
            color: Colors.white12,
          ),
          const Gap(10),
          // start scanner
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.bottomSheet(
                buildScanner(),
                isScrollControlled: true,
              );
            },
            child: const Row(
              children: [
                MyText(
                  txt: "اسکن کد دستگاه",
                  size: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                Gap(10),
                Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const Spacer(),
          MyButton(
            onPressed: () {
              if ((textEditingController.text.isEmpty ||
                          textEditingController.text.length != 4) &&
                      token == null ||
                  token!.isEmpty) {
                Get.snackbar("خطا", "کد دستگاه را اسکن کنید یا وارد کنید");
              }

              onSubmit(token, textEditingController.text);
            },
            text: "ثبت دستگاه",
          ),
          const Gap(20),
        ],
      ),
    );
  }
}
