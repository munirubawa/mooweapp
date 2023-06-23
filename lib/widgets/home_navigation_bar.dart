import 'package:mooweapp/export_files.dart';

class HomeNavigationBar extends StatefulWidget {
  // int page ;
  int tabIndex;
  Color backgroudColor;
  HomeNavigationBar({
    required this.tabIndex,
    required this.backgroudColor,
    Key? key,
  }) : super(key: key);

  @override
  _HomeNavigationBarState createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  int currentIndex = 0;
  int pageIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: Get.width * .06,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      backgroundColor: widget.backgroudColor,
      currentIndex: widget.tabIndex,
      elevation: 0.0,
      onTap: (index) {
        print("page index: $pageIndex  $index");
        currentIndex = 0;
        pageIndex = index;
        switch (index) {
          case 0:
            if(index != navController.pageIndex.value){
              navController.pageIndex.value = 0;
              if(navController.callStatus.value == CallActionStatus.CALL_START) {
                navController.pipPage = const AuthHomeScreen();
                navController.smallScreen();
              } else {
                Get.offAllNamed(RoutesClass.getHomeRoute());
              }
            }

            break;
          case 1:
            if(index != navController.pageIndex.value){
              navController.pageIndex.value = 1;
              if(navController.callStatus.value == CallActionStatus.CALL_START) {
                navController.pipPage = const MoowePayHomeScreen();
                navController.smallScreen();
              } else {
                Get.toNamed(RoutesClass.getMowePayRoute());
              }
            }
            break;
          case 2:
            if(index != navController.pageIndex.value){
              navController.pageIndex.value = 2;
              if(navController.callStatus.value == CallActionStatus.CALL_START) {
                navController.pipPage = const SettingScreen();
                navController.smallScreen();
              } else {
                Get.toNamed(RoutesClass.getSettingScreen());
              }
            }


            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: "Chats",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: "Pay",
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.directions_car_outlined),
        //   label: "RideShare",
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}
