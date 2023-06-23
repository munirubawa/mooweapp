
import 'package:mooweapp/export_files.dart';
class ChatAvator extends StatelessWidget {
  ChatRoom? chat;


  ChatAvator({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   double radius = imageRadius + 6;
    switch (chat!.chatType!) {
      case ChatTypes.PRIVATE_CHAT:
        // TODO: Handle this case.
        String iamge = chat!.groupImages!.firstWhere((element) => element != chatServices.localMember!.get(memberModel.
        imageUrl));
        return CircleAvatar(
          radius: radius,
          child: storage.checkImage(iamge)
              ? Container(
            decoration: BoxDecoration(
              // color: Colors.orange,
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: storage.getImage(
                      iamge,
                    ),
                    fit: BoxFit.cover)),
          ): CircleAvatar(
            radius: radius,
            child: storage.networkImage(iamge,),
          ),
        );
      case ChatTypes.BUSINESS_CHAT:
      case ChatTypes.STORE_CHAT:
      return Stack(
        children: [
          CircleAvatar(
            radius: imageRadius  + 7,
            child: storage.checkImage(chat!.imageUrl.toString())
                ? CircleAvatar(
              radius: radius + 10,
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.orange,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: storage.getImage(
                          chat!.imageUrl.toString(),
                        ),
                        fit: BoxFit.cover)),
              ),
            ): CircleAvatar(
              radius: radius + 10,
              child: storage.networkImage(chat!.imageUrl.toString(),),
            ),
          ),
          const Positioned(
            top: 0,
            right: 0,
              child: Icon(Icons.store, size: 15, color: kPrimaryColor),
          ),
        ],
      );
      case ChatTypes.PROJECT_CHAT:
      case ChatTypes.GROUP_CHAT:
        return CircleAvatar(
            radius: imageRadius  + 7,
          child: storage.checkImage(chat!.imageUrl.toString())
              ? CircleAvatar(
            radius: radius + 10,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.orange,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: storage.getImage(
                        chat!.imageUrl.toString(),
                      ),
                      fit: BoxFit.cover)),
            ),
          ): CircleAvatar(
            radius: radius + 10,

            child: storage.networkImage(chat!.imageUrl.toString(),),
          ),
        );
      case ChatTypes.FUND_RAISE:
        // TODO: Handle this case.
        return Container();
      case ChatTypes.SUSU:
        // TODO: Handle this case.
        return Container();

    }
  }

  Widget groupCircleAvatar(String? sender) {
    return storage.checkImage(sender!)
        ? CircleAvatar(
      radius: Get.width * 0.2,
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.orange,
            shape: BoxShape.circle,
            image: DecorationImage(
                image: storage.getImage(
                  sender,
                ),
                fit: BoxFit.cover)),
      ),
    )
        : storage.networkImage(sender);
  }
}
