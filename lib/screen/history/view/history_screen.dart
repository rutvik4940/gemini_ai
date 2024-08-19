import 'package:flutter/material.dart';
import 'package:gemini_app/screen/home/controller/home_controller.dart';
import 'package:gemini_app/utils/helper/db_helper.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HomeController controller = Get.put(HomeController());
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    controller.readData();
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

  bool isQuestion(String text) {
    return text
        .trim()
        .endsWith('?'); // Check if the text ends with a question mark
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "History",
          style: TextStyle(fontFamily: "f1", color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/image/d2.png",
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            fit: BoxFit.cover,
          ),
          Obx(
            () => ScrollablePositionedList.builder(
              itemCount: controller.likelist.length,
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              itemBuilder: (context, index) {
                bool isQus =
                    isQuestion(controller.likelist[index].text as String);
                return Align(
                  alignment:
                      isQus ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 100,
                      maxWidth: MediaQuery.sizeOf(context).width * 0.60,
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.defaultDialog(
                          content: Text("ARE YOU SURE"),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                DbHelper.helper
                                    .delete(controller.likelist[index].id!);
                                controller.readData();
                                Get.back();
                              },
                              child: Text("Yes",style: TextStyle(color: Colors.red),),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("No",style: TextStyle(color: Colors.green),),
                            ),
                          ],
                        );
                      },
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
                            bottomLeft: Radius.circular(isQus ? 15 : 0),
                            bottomRight: Radius.circular(isQus ? 0 : 15),
                          ),
                        ),
                        child: Text(
                          "${controller.likelist[index].text}",
                          style: const TextStyle(
                            fontFamily: "f1",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
