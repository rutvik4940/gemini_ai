import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:gemini_app/screen/home/controller/home_controller.dart';
import 'package:gemini_app/utils/helper/db_helper.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:theme_change/theme_change.dart';

import '../../../utils/network/network_connectivity.dart';
import '../../history/model/db_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController controller = Get.put(HomeController());
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  TextEditingController txtMsg = TextEditingController();
  final formKey = GlobalKey<FormState>();
  NetworkConnection connection = NetworkConnection();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connection.checkConnection();
  }

  void scrollToBottom() {
    if (controller.list.isNotEmpty) {
      itemScrollController.scrollTo(
        index: controller.list.length - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("History"),
                onTap: () {
                  Get.toNamed('like');
                },
              ),
            ],
          )
        ],
        centerTitle: true,
        title: const Text(
          "Genimi app",
          style: TextStyle(color: Colors.white, fontFamily: "f1"),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(
        () => controller.isOnline.value
            ? Stack(
                children: [
                  Image.asset(
                    "assets/image/d2.png",
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    fit: BoxFit.cover,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Obx(
                            () => ScrollablePositionedList.builder(
                              itemCount: controller.list.length,
                              itemScrollController: itemScrollController,
                              itemPositionsListener: itemPositionsListener,
                              itemBuilder: (context, index) {
                                bool isQus = index % 2 == 0;
                                return Align(
                                  alignment: isQus
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 100,
                                      maxWidth:
                                          MediaQuery.sizeOf(context).width *
                                              0.60,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isQus
                                            ? const Color(0xff5B99C2)
                                            : const Color(0xffC9DABF),
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(15),
                                          topRight: const Radius.circular(15),
                                          bottomLeft:
                                              Radius.circular(isQus ? 15 : 0),
                                          bottomRight:
                                              Radius.circular(isQus ? 0 : 15),
                                        ),
                                      ),
                                      child: Text(
                                        "${controller.list[index]}",
                                        style: const TextStyle(
                                          fontFamily: "f1",
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            onSubmitted: (value) async {
                              if (value.isNotEmpty) {
                                controller.list.add(value);
                                await controller.getDataGemini(value);
                                DbModel db = DbModel(text: value);
                                DbHelper.helper.insert(db);
                                scrollToBottom(); // Scroll to bottom after adding message
                                txtMsg.clear(); // Clear the text field
                                FocusScope.of(context).unfocus();
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            controller: txtMsg,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintText: "Message...",
                              hintStyle: const TextStyle(
                                  color: Colors.white, fontFamily: "f1"),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  if (txtMsg.text.isNotEmpty) {
                                    controller.list.add(txtMsg.text);
                                    await controller.getDataGemini(txtMsg.text);
                                    DbModel db = DbModel(text: txtMsg.text);
                                    DbHelper.helper.insert(db);
                                    scrollToBottom(); // Scroll to bottom after adding message
                                    txtMsg.clear(); // Clear the text field
                                  }
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Center(
              child: const Text(
                  "No internet",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,fontFamily: "f1"),
                ),
            ),
      ),
    );
  }
}
