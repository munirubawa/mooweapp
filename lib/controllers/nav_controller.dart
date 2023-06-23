import 'package:mooweapp/export_files.dart';
class NavController extends GetxController {
  static NavController instance = Get.find();
  RxList<int> popIndex = RxList([]);
  RxInt pageIndex = RxInt(0);
  BuildContext? pipContext;
  Widget? pipPage;
  Rx<CallActionStatus> callStatus = CallActionStatus.END_CALL.obs;
  void popTabUpdate() {
    if (popIndex.length > 1) {
      popIndex.value.removeAt(pageIndex.value);
      pageIndex.value = popIndex.value.last;
    } else {
      pageIndex.value = popIndex.value.last;
    }
    print(popIndex.value);
  }

  void smallScreen() {
    // Get.toNamed(RoutesClass.getMowePayRoute());
    print("smallScreen");
    if (pipPage != null && pipContext != null && callStatus.value == CallActionStatus.CALL_START) {
      runSystemOverlay();
      Future.delayed(const Duration(seconds: 1), () {
        PIPView.of(pipContext!)?.presentBelow(pipPage!);
      });
    } else {
      print("no small screen");
      print(pipPage == null);
      print(pipContext == null);
      print(callStatus.value == CallActionStatus.CALL_START);
    }
  }
}
