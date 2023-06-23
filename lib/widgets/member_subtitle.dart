import 'package:mooweapp/export_files.dart';

class MemberSubTitle extends StatelessWidget {
  DocumentSnapshot? member;
  ChatRoom? chatRoom;
  MemberSubTitle({Key? key, required this.member, required this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch(chatRoom!.chatType) {

      case ChatTypes.PRIVATE_CHAT:
        // TODO: Handle this case.
        return Container();
      case ChatTypes.GROUP_CHAT:
        // TODO: Handle this case.
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,

          children: [
            Row(
              children: [
                Expanded(child: Text("${member!.get(memberModel.phone)} "))
              ],
            ),

            chatRoom!.currentBeneficiary! == member!.get(memberModel.userUID)  ?Row(
              children: const [
                Text("Funds Beneficiary",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                  ),
                )
              ],
            ): Container(),
            chatRoom!.admins!.contains(member!.get(memberModel.userUID))  ?Row(
              children: const [
                Text("Admin",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                  ),
                )
              ],
            ): Container(),
            chatRoom!.supperAdmin!.contains(member!.get(memberModel.userUID))  ?Row(
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
        );
      case ChatTypes.PROJECT_CHAT:
        // TODO: Handle this case.
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
              chatRoom!.manager == member!.get(memberModel.userUID)? Row(
                children: const [
                  Text(" Project Manager")
                ],
              ): Container(),

              chatRoom!.admins!.contains(member!.get(memberModel.userUID))  ?Row(
                children: const [
                  Text("Admin",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ): Container(),
              chatRoom!.supperAdmin!.contains(member!.get(memberModel.userUID))  ?Row(
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
        case ChatTypes.BUSINESS_CHAT:
        // TODO: Handle this case.
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,

          children: [
            Row(
              children: [
                Text("${member!.get(memberModel.phone)} ")
              ],
            ),
            chatRoom!.manager == member!.get(memberModel.userUID)? Row(
              children: const [
                Text(" Manager", style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold
                ),)
              ],
            ): Container(),

            chatRoom!.admins!.contains(member!.get(memberModel.userUID))  ?Row(
              children: const [
                Text("Admin",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                  ),
                )
              ],
            ): Container(),
            chatRoom!.supperAdmin!.contains(member!.get(memberModel.userUID))  ?Row(
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
        );
      case ChatTypes.FUND_RAISE:
        // TODO: Handle this case.
        return Container(
        );
      case ChatTypes.SUSU:
        // TODO: Handle this case.
        return Container(
        );
      default:
        return Container();
    }
  }
}
