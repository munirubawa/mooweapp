import 'package:mooweapp/export_files.dart';
class AffiliateMember extends StatelessWidget {
  AffiliateMember({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // newChatAction = actionType;
    TextStyle textStyle = themeData!.textTheme.headline6!.copyWith(color: Colors.black);
    var f = NumberFormat(
      "#,###.##",
      "en_US",
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white,
            pinned: false,
            snap: true,
            floating: true,
            expandedHeight: Get.width * 0.4,
            title: Text('Affiliate members', style: textStyle),
            flexibleSpace: FlexibleSpaceBar(
              title: Obx((){
                double totalEarned = affiliateController.members.value.fold(0, (previousValue, element) => previousValue.toDouble() + element.get("earned"));
                return Text(
                  "${chatServices.localMember!.get(memberModel.currencySign)}${paymentsController.numCurrency(totalEarned)}",
                  style: textStyle.copyWith(fontSize: Get.width * 0.08, color: Colors.black),
                );
              }),
              // background: FlutterLogo(),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: Get.width * 0.10,
              child: Column(
                children: [
                  const Expanded(
                      child: Center(
                    child: Text('Earned'),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text('${affiliateController.members.value.length} subscribers')],
                    ),
                  )),
                ],
              ),
            ),
          ),

          Obx(() => SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                DocumentSnapshot member = affiliateController.members.value.elementAt(index);
                return Container(
                  color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(
                    child: ListTile(
                      onTap: () {},
                      leading: CircleAvatar(
                          radius: imageRadius,
                          child: storage.networkImage(member.get("imageUrl"))),

                      title: Text(
                        "${member.get("firstName")} ${member.get("lastName")}",
                        overflow: TextOverflow.ellipsis,
                        style: themeData!.textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        "${member.get("currencyCode")} ${paymentsController.numCurrency(member.get("earned").toDouble())}",
                        style: themeData!.textTheme.headline6!.copyWith(fontSize: 14),
                      ),
                      trailing: CircleAvatar(radius: imageRadius, backgroundImage: const AssetImage('assets/mowe_logo_round.png')),
                    ),
                  ),
                );
              },
              childCount: affiliateController.members.value.length,
            ),
          ),
          ),
        ],
      ),
    );
  }
}
