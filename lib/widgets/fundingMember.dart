import 'package:mooweapp/export_files.dart';

class FundingMember extends StatefulWidget {
  DocumentSnapshot member;
  ChatRoom chatRoom;
   FundingMember({Key? key, required this.member, required this.chatRoom}) : super(key: key);

  @override
  State<FundingMember> createState() => _FundingMemberState();
}

class _FundingMemberState extends State<FundingMember> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        title: Text(
          "Funding: ${widget.member.get(memberModel.firstName)}  ${widget.member.get(memberModel.lastName)}",
          overflow: TextOverflow.fade,
          style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  children:  [
                    NumberDisplay(),
                  ],
                ),
              )),
          Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  children: [
                    KeyPadDisplay(),
                  ],
                ),
              )),
          Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        child: const Text("Fund"),
                        onPressed: () {
                          transactionService.context = context;
                          transactionService.member = widget.member;
                          transactionService.chatRoom = widget.chatRoom;
                          enumServices.transactionActionType = TransactionActionType.FUND_A_MEMBER;
                          transactionService.runTransaction();
                        },
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
