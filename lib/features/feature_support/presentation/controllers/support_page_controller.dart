import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_support/data/model/message_model.dart';

import 'package:movie_chi/features/feature_support/domain/usecases/support_use_case.dart';
import 'package:pinput/pinput.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class SupportPageController extends GetxController {
  SupportUseCase supportUseCase;
  SupportPageController({required this.supportUseCase});

  PageStatus pageStatus = PageStatus.loading;
  PageStatus typeStatus = PageStatus.empty;

  MessageClassModel messageClassModel = MessageClassModel();

  TextEditingController messageController = TextEditingController();

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  int page = -1;
  @override
  void onReady() {
    super.onReady();

    getMessage();
  }

  getMessage() async {
    page++;
    pageStatus = PageStatus.loading;
    DataState supportMessage = await supportUseCase.getSupportMessages(page);

    if (supportMessage is DataSuccess) {
      pageStatus = PageStatus.success;

      MessageClassModel messageClassModel = (supportMessage.data);

      if (messageClassModel.data!.isEmpty) {
        if ((this.messageClassModel.data ?? []).isEmpty) {
          pageStatus = PageStatus.empty;
        } else {
          pageStatus = PageStatus.success;
        }
      } else {
        pageStatus = PageStatus.success;
      }
      if ((this.messageClassModel.data ?? []).isEmpty) {
        this.messageClassModel = messageClassModel;
      } else {
        for (var item in messageClassModel.data ?? []) {
          this.messageClassModel.data!.add(item);
        }
      }

      update(["message"]);
    } else {
      pageStatus = PageStatus.error;
      update();
    }
  }

  sendMessage() async {
    if (messageController.text.isEmpty) return;
    typeStatus = PageStatus.loading;
    update(["typing"]);
    DataState supportMessage =
        await supportUseCase.sendSupportText(messageController.text);

    if (supportMessage is DataSuccess) {
      pageStatus = PageStatus.success;

      MessageClassModel messageClassModel = (supportMessage.data);
      if (messageClassModel.data!.isEmpty) {
        pageStatus = PageStatus.empty;
      } else {
        pageStatus = PageStatus.success;
      }
      page = 0;
      this.messageClassModel = messageClassModel;
      typeStatus = PageStatus.success;
      messageController.setText("");
      update(["message", "typing"]);
    } else {
      pageStatus = PageStatus.error;
      typeStatus = PageStatus.error;

      update(["message", "typing"]);
    }
  }

  refreshAgain() {
    page = -1;
    messageClassModel.data = [];
    pageStatus = PageStatus.loading;
    update(["message"]);
    getMessage();
  }
}
