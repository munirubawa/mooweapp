import 'package:mooweapp/export_files.dart';
class UserTransactionHistory extends StatelessWidget {
  const UserTransactionHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: (){
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title:  Text("History", style: themeData!.textTheme.headline6,),
      ),
      body: const SingleChildScrollView(
        child: MooweCashActivityScreen(),
      ),
    );
  }
}
