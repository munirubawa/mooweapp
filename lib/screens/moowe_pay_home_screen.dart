import 'package:mooweapp/export_files.dart';


class MoowePayHomeScreen extends StatefulWidget {

  const MoowePayHomeScreen({Key? key, }) : super(key: key);

  @override
  _MoowePayHomeScreenState createState() => _MoowePayHomeScreenState();
}

class _MoowePayHomeScreenState extends State<MoowePayHomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    runSystemOverlay();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: GestureDetector(
        onTap: (){
          runSystemOverlay();
        },
        child: Scaffold(
          key: UniqueKey(),
          backgroundColor: kPrimaryColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: kPrimaryColor,
            title: Obx(()=>Row(
              children:  [
                Text("${paymentsController.numCurrency(transactionService.accountBalance.value)} ",
                  style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),),
                Text(chatServices.localMember!.get(memberModel.currencyCode).toString()),

                // Text(gl.localUser.defaultCard.currency),
              ],
            )),
            centerTitle: true,
            actions: [
              // IconButton(
              //   onPressed: () {
              //     if (contactServices.contactsPermissionGranted) {
              //       if(chatServices.localMember!.get(memberModel.affiliateActive)){
              //         // Get.to(()=>  const AffiliatedProgram());
              //       } else{
              //         Get.defaultDialog(
              //           title: "Activation",
              //           content: Text("Would you like to activate your affiliates account?",textAlign: TextAlign.center, style: themeData!.textTheme.bodyLarge),
              //           confirm: SizedBox(
              //             height: 35,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceAround,
              //               children: [
              //                 TextButton(onPressed: (){}, child: const Text("Cancel"),),
              //                 TextButton(onPressed: (){
              //                   Get.back();
              //                   chatServices.localMember!.reference.update({memberModel.affiliateActive: true});
              //                   showLoading(message: "activation in progress");
              //                   Future.delayed(const Duration(seconds: 5), (){
              //                     dismissLoadingWidget();
              //                   }).then((value){
              //                     showToastMessage(msg: "Affiliate program has been activated");
              //                   });
              //                 }, child: const Text("Activate")),
              //               ],
              //             ),
              //           )
              //         );
              //       }
              //
              //     } else {
              //       permissionController.getContactPermission();
              //     }
              //   },
              //   icon: const Icon(
              //     Icons.person_add_alt,
              //     color: Colors.white,
              //   ),
              // ),
              IconButton(
                onPressed: () {
                  Get.to(()=>  const UserTransactionHistory());

                },
                icon: const Icon(
                  Icons.history_sharp,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.to(()=>  const SettingScreen( ));

                },
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ],

          ),
          body: MooweCashScreen(),
          bottomNavigationBar: HomeNavigationBar(tabIndex: 1, backgroudColor: kPrimaryColor,),
        ),
      ),
    );
  }


}
