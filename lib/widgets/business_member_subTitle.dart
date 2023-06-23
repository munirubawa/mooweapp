import 'package:mooweapp/export_files.dart';
class BusinessMemberSubTitle extends StatelessWidget {
  DocumentSnapshot? member;
  Business? business;
  BusinessMemberSubTitle({Key? key, required this.member, required this.business}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(
     // color: red,
     child: Column(
       mainAxisAlignment: MainAxisAlignment.end,

       children: [
         Row(
           children: [
             Text("${member!.get(memberModel.phone)} ")
           ],
         ),
         business!.manager == member!.get(memberModel.userUID)? Row(
           children: const [
             Text(" Project Manager")
           ],
         ): Container(),

         business!.admins!.contains(member!.get(memberModel.userUID))  ?Row(
           children: const [
             Text("Admin",
               style: TextStyle(
                   color: Colors.green,
                   fontWeight: FontWeight.bold
               ),
             )
           ],
         ): Container(),
         business!.supperAdmin!.contains(member!.get(memberModel.userUID))  ?Row(
           children: const [
             Text("Supper Admin",
               style: TextStyle(
                   color: Colors.green,
                   fontWeight: FontWeight.bold
               ),
             )
           ],
         ): Container(),
       ],
     ),
   );
  }
}