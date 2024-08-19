import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:gemini_app/utils/helper/api_helper.dart';
import 'package:gemini_app/utils/helper/db_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../history/model/db_model.dart';
import '../model/home_model.dart';

class HomeController extends GetxController {
  Rxn<HomeModel> model = Rxn<HomeModel>();
  RxList<String> list = <String>[].obs;
  RxList<DbModel> likelist = <DbModel>[].obs;
  RxBool isOnline = false.obs;
  final Connectivity connectivity = Connectivity();
  bool isConnected = true;

  Future<void> getDataGemini(String question) async {
    HomeModel? m1 = await ApiHelper.helper.getData(question);
    model.value = m1;
    if (model.value != null) {
      DbModel m3 = DbModel(text: model.value!.list![0].content!.l1![0].text!);
      DbHelper.helper.insert(m3);
      list.add(model.value!.list![0].content!.l1![0].text!);
    }
  }

  Future<void> readData() async {
    List<DbModel> d1 = await DbHelper.helper.read();
    if (d1 != null) {
      likelist.value = d1;
    }
  }
  void changeStatus(bool status) {
    isOnline.value = status;
  }


}
