import 'package:mooweapp/export_files.dart';
class ContactBody extends StatefulWidget {
  Function()? press;
  DocumentSnapshot? member;
  ContactBody({Key? key, this.press, required this.member}) : super(key: key);

  @override
  State<ContactBody> createState() => _ContactBodyState();
}

class _ContactBodyState extends State<ContactBody> {
  // var con_serv = locator.get<ContactServices>();
  @override
  Widget build(BuildContext context) {
    switch (enumServices.chatTypes!) {
      case ChatTypes.PRIVATE_CHAT:
        // TODO: Handle this case.
        return ListTile(
          onTap: widget.press,
          leading: CircleAvatar(
            radius: imageRadius,
            child: storage.networkImage(widget.member!.get(memberModel.imageUrl)),
          ),
          title: Text(
            "${widget.member!.get(memberModel.firstName)} ${widget.member!.get(memberModel.lastName)}",
            overflow: TextOverflow.ellipsis,
            style: themeData!.textTheme.bodyLarge,
          ),
          subtitle: Text(
            widget.member!.get(memberModel.phone),
            style: themeData!.textTheme.bodySmall,
          ),
          trailing: CircleAvatar(
              radius: imageRadius, backgroundImage: const AssetImage('assets/mowe_logo_round.png')),
        );
      case ChatTypes.GROUP_CHAT:
        return groupProject();
      case ChatTypes.PROJECT_CHAT:
        // TODO: Handle this case.
        return groupProject();
      case ChatTypes.FUND_RAISE:
        return groupProject();
      case ChatTypes.SUSU:
        return groupProject();
      case ChatTypes.BUSINESS_CHAT:
        return groupProject();
      case ChatTypes.STORE_CHAT:
        return groupProject();
    }
  }


  bool _toggle = false;
  Widget groupProject() {
    switch(enumServices.userActionType) {

      case UserActionType.CREATE_NEW_CHAT:
        // TODO: Handle this case.
        return CheckboxListTile(
          value: _toggle,
          activeColor: kPrimaryColor,
          checkColor: Colors.white,
          onChanged: (bool? value) {
            setState(() {
              _toggle = value!;

              var member = groupOrProjectMembers.firstWhereOrNull((element){
                return element.get(memberModel.userUID) == widget.member!.get(memberModel.userUID);
              });
              if(_toggle && member == null) {
                groupOrProjectMembers.add(widget.member!);
              }if(!_toggle && member != null) {
                groupOrProjectMembers.removeWhere((element) => element.get(memberModel.userUID) == widget.member!.get(memberModel.userUID));
              }
              print(groupOrProjectMembers.length);

              final List token = groupOrProjectMembers.map((m) => m.get(memberModel.deviceToken)).toList();
              print(token);
            });
          },
          // leading: CircleAvatar(
          //   radius: SizeConfig.heightMultiplier! * 3.4,
          //   child: storage.networkImage(widget.member!.imageUrl.toString()),
          // ),
          title: Text(
            "${widget.member!.get(memberModel.firstName)} ${widget.member!.get(memberModel.lastName)}",
            overflow: TextOverflow.ellipsis,
            style: themeData!.textTheme.bodyLarge,
          ),
          subtitle: Text(
            widget.member!.get(memberModel.phone).toString(),
            style: themeData!.textTheme.bodySmall,
          ),
          // trailing: CircleAvatar(
          //     radius: SizeConfig.heightMultiplier! * 3,
          //     backgroundImage: const AssetImage('assets/contact_icon2.png')
          // ),
        );

      case UserActionType.ADD_NEW_MEMBER_TO_GROUP_OR_PROJECT:
      case UserActionType.CREATE_NEW_GROUP_OR_PROJECT_CHAT:
        // TODO: Handle this case.
        return CheckboxListTile(
          value: _toggle,
          activeColor: kPrimaryColor,
          checkColor: Colors.white,
          onChanged: (bool? value) {
            setState(() {
              _toggle = value!;

              var member = groupOrProjectMembers.firstWhereOrNull((element){
                return element.get(memberModel.userUID) == widget.member!.get(memberModel.userUID);
              });
              if(_toggle && member == null) {
                groupOrProjectMembers.add(widget.member!);
              }if(!_toggle && member != null) {
                groupOrProjectMembers.removeWhere((element) => element.get(memberModel.userUID) == widget.member!.get(memberModel.userUID));
              }
              if (kDebugMode) {
                print(groupOrProjectMembers.length);
              }

              final List token = groupOrProjectMembers.map((m) => m.get(memberModel.deviceToken)).toList();
              if (kDebugMode) {
                print(token);
              }
            });
          },
          // leading: CircleAvatar(
          //   radius: SizeConfig.heightMultiplier! * 3.4,
          //   child: storage.networkImage(widget.member!.imageUrl.toString()),
          // ),
          title: Text(
            "${widget.member!.get(memberModel.firstName)} ${widget.member!.get(memberModel.lastName)}",
            overflow: TextOverflow.ellipsis,
            style: themeData!.textTheme.bodyLarge,
          ),
          subtitle: Text(
            widget.member!.get(memberModel.phone).toString(),
            style: themeData!.textTheme.bodySmall,
          ),
          // trailing: CircleAvatar(
          //     radius: SizeConfig.heightMultiplier! * 3,
          //     backgroundImage: const AssetImage('assets/contact_icon2.png')
          // ),
        );
      case UserActionType.SEND_CASH_DIRECT_FROM_MOOWE_PAY:
      case UserActionType.CREATE_CONTRACT:
      case UserActionType.SEND_CASH_IN_PRIVATE_CHAT:
      case UserActionType.SEND_CASH_IN_GROUP_CHAT:
      case UserActionType.SEND_CASH_PROJECT_CHAT:
      case UserActionType.SEND_CASH_TO_MOMO:
      case UserActionType.SEND_CASH_TO_BANK_ACCOUNT:
      case UserActionType.CASH_OUT_TO_BANK_ACCOUNT:
      case UserActionType.PAY_INTO_CONTRACT:
      case UserActionType.PROCESS_CONTRACT:
      case UserActionType.BILL_PAY:
      case UserActionType.REQUEST_PAYMENT:
      case UserActionType.TRANSFER_CASH_TO_BANK:
      case UserActionType.ADD_MEMBER_TO_BUSINESS_ACCOUNT:
        // TODO: Handle this case.
        return Container();
      default:
        return Container();
    }

  }
}
