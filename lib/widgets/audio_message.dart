import 'package:mooweapp/export_files.dart';
const kDefaultPadding = 20.0;

class AudioMessage extends StatelessWidget {
  DocumentSnapshot? message;

   AudioMessage({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  chatServices.localMember!.get(memberModel.userUID) == message!.get(messagePayloadModel.sender)[messageSenderModel.userUID]?  Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kPrimaryColor.withOpacity( 1 ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.white,
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Text(
            "0.37",
            style: TextStyle(
                fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    )  :  Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kPrimaryColor.withOpacity(0.1 ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.play_arrow,
            color: kPrimaryColor ,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: kPrimaryColor.withOpacity(0.4),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Text(
            "0.37",
            style: TextStyle(
                fontSize: 12, color:  null),
          ),
        ],
      ),
    );
  }
}