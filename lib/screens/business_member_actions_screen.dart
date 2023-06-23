import 'package:mooweapp/export_files.dart';

class BusinessMemberActionScreen extends StatefulWidget {
  final Business? business;
  DocumentSnapshot? member;
   BusinessMemberActionScreen({Key? key, this.business, this.member}) : super(key: key);

  @override
  _BusinessMemberActionScreenState createState() => _BusinessMemberActionScreenState();
}

class _BusinessMemberActionScreenState extends State<BusinessMemberActionScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: const Text("Actions"),
        actions: const [
          // widget.chat!.chatRoom!.supperAdmin == chatServices.localUser!.userUID
          //               ? ButtonBar(
          //             mainAxisSize: MainAxisSize.max, // this will take space as minimum as posible(to center)
          //             buttonPadding: EdgeInsets.only(right: 15),
          //             children: <Widget>[
          //               // IconButton(
          //               //   icon: Icon(Icons.message_outlined),
          //               //   onPressed: null,
          //               // ),
          //               IconButton(
          //                 icon: Icon(Icons.monetization_on_outlined),
          //                 onPressed: () {
          //                   changeScreen(context, ChatMoneyKeyPad(
          //                     member: member,
          //                     chat: widget.chat,
          //                   ));
          //
          //                 },
          //               ),
          //             ],
          //           ): Container(),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: storage.checkImage(widget.member!.get(memberModel.imageUrl).toString())
                ? CircleAvatar(
              radius: Get.width * 0.2,
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.orange,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: storage.getImage(
                          widget.member!.get(memberModel.imageUrl),
                        ),
                        fit: BoxFit.cover)),
              ),
            )
                : Container(
              child: Icon(Icons.person, size: Get.width * 0.15,),
            ),
            title: Text("${widget.member!.get(memberModel.firstName)} ${widget.member!.get(memberModel.lastName)}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold
              ),),
            isThreeLine: true,
            subtitle: BusinessMemberSubTitle(member: widget.member, business: widget.business,),
            trailing: GestureDetector(
              onTap: (){
                print("red button");
              },
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: Get.width * 0.2,
                      // color: Colors.red,
                      child: Row(
                        children: const [
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),


          widget.business!.supperAdmin!.contains(chatServices.localMember!.get(memberModel.userUID)) &&
              widget.member!.get(memberModel.userUID) != auth.currentUser!.uid
              ? Padding(padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Padding(padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async{
                          widget.business!.snapshot!.reference.set({"admins": FieldValue.arrayUnion([widget.member!.get(memberModel.userUID)!])}, SetOptions(merge: true));
                          Navigator.of(context).pop();
                          showToastMessage(msg: "Granted Successful", backgroundColor: Colors.green);
                        },
                        child: const Text("admin"),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async{

                          widget.business!.snapshot!.reference.set({"admins": FieldValue.arrayRemove([widget.member!.get(memberModel.userUID)])}, SetOptions(merge: true));
                          Navigator.of(context).pop();
                          showToastMessage(msg: "Revoked Successful", backgroundColor: Colors.green);
                        },
                        child: const Text("Revoke "),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Padding(padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async{
                          widget.business!.snapshot!.reference.set({"supperAdmin": FieldValue.arrayUnion([widget.member!.get(memberModel.userUID)!])}, SetOptions(merge: true));
                          Navigator.of(context).pop();
                          showToastMessage(msg: "Granted Successful", backgroundColor: Colors.green);
                        },
                        child: const Text("Supper Admin"),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async{
                          widget.business!.snapshot!.reference.set({"supperAdmin": FieldValue.arrayRemove([widget.member!.get(memberModel.userUID)])}, SetOptions(merge: true));
                          Navigator.of(context).pop();
                          showToastMessage(msg: "Revoked Successful", backgroundColor: Colors.green);
                        },
                        child: const Text("Revoke"),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Text("Grant Manager"),
                        onPressed: ()async {
                          // chatServices.chatRoom =widget.business;
                          // chatServices.member =widget.member;
                          // enumServices.chatServicesActions = ChatServicesActions.MAKE_MEMBER_PROJECT_MANAGER;
                          // chatServices.runChatServices();
                          Navigator.of(context).pop();

                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Text("Revoke"),
                        onPressed: ()async {
                          // print(member.docId);
                          businessServices.business.value = widget.business!;

                          chatServices.runChatServices();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),

                // Row(
                //   children: [
                //     Padding(padding: EdgeInsets.all(10),
                //       child: ElevatedButton(
                //         child: Text("Create Contract"),
                //         onPressed: (){
                //           // transactionService.contract!.creator = chatServices.localUser!.member;
                //           // transactionService.contract!.receiver = widget.member;
                //           // transactionService.contract!.creditCard = widget.chatRoom!.creditCard;
                //           // transactionService.contract!.chatRoom = widget.chatRoom;
                //           // transactionService.contract!.contractId = widget.chatRoom!.chatRoomPathDocId;
                //           // transactionService.chatRoom = widget.chatRoom;
                //           //
                //           // changeScreen(context, CreateContractScreen());
                //         },
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ): Container(),

        ],
      ),
    );
  }
}