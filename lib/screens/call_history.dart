import 'package:mooweapp/export_files.dart';

class CallHistory extends StatelessWidget {
  const CallHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
        children: callHistoryController.userCallHistory.isNotEmpty
            ? callHistoryController.userCallHistory
                .map((DocumentSnapshot callDetail) {
                return InkWell(
                  onTap: () {
                    Map<String, dynamic> callData =
                        callDetail.data() as Map<String, dynamic>;
                    if (permissionController.audioPermissionGranted.value &&
                        permissionController.cameraPermissionGranted.value) {
                      navController.callStatus.value =
                          CallActionStatus.CALL_START;

                      Map<String, dynamic> callFrom =
                          callDetail.get(callActionDetailsModel.callFrom);
                      Map<String, dynamic> callTo =
                          callDetail.get(callActionDetailsModel.callTo);

                      callData[callActionDetailsModel.callFrom] = callTo;
                      callData[callActionDetailsModel.callTo] = callFrom;
                      callData[callActionDetailsModel.callerCandidate] = [];
                      callData[callActionDetailsModel.receiverCandidate] = [];
                      callData[callActionDetailsModel.callResponds] = EnumToString.convertToString(CallResponds.INCOMING_CALL);
                      callData[callActionDetailsModel.callActionStatus] = EnumToString.convertToString(CallActionStatus.CALL_START);
                      signal.callActionDetailsData = callData;
                      // signalingController.showCallScreen(IncomingCallOrOutGoingCall.OUTGOING_CALL);
                      signal.callDirection.value = IncomingCallOrOutGoingCall.OUTGOING_CALL;

                    } else {
                      if (!permissionController.audioPermissionGranted.value) {
                        permissionController.getMicrophonePermission();
                      } else if (!permissionController
                          .cameraPermissionGranted.value) {
                        permissionController.getCameraPermission();
                      }
                    }
                    // contractController.contractSnap = contract;
                    // contractController.contractData.value =
                    // contract.data() as Map<String, dynamic>;
                    // Get.to(() => ViewContract());
                  },
                  child: CallDetail(
                    callDetail: callDetail,
                  ),
                );
              }).toList()
            : [
                const Center(
                  child: Text("No calls"),
                )
              ]));
  }
}

class CallDetail extends StatelessWidget {
  DocumentSnapshot callDetail;
  CallDetail({Key? key, required this.callDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String image = callDetail
        .get(callActionDetailsModel.callFrom)[memberCallInfoModel.imageUrl];
    String firstName = callDetail
        .get(callActionDetailsModel.callFrom)[memberCallInfoModel.firstName];
    String lastName = callDetail
        .get(callActionDetailsModel.callFrom)[memberCallInfoModel.lastName];
    String callType = callDetail.get(callActionDetailsModel.callType);
    Timestamp time = callDetail.get(callActionDetailsModel.time);
    String status = callDetail.get(callActionDetailsModel.callActionStatus);
    return ListTile(
      contentPadding: const EdgeInsets.all(5),
      leading: CircleAvatar(
        radius: imageRadius,
        child: storage.checkImage(image)
            ? Container(
                decoration: BoxDecoration(
                    // color: Colors.orange,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: storage.getImage(
                          image,
                        ),
                        fit: BoxFit.cover)),
              )
            : CircleAvatar(
                radius: imageRadius,
                child: storage.networkImage(
                  image,
                ),
              ),
      ),
      title: Text("${firstName} ${lastName}", style: textStyle(status),),
      subtitle: Row(
        children: [
          callVideoVoice(callType),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(CallTimeStamp(time).time()),
          ),
        ],
      ),
    );
  }

  TextStyle? textStyle(String  status){
    CallActionStatus? actionStatus = EnumToString.fromString(CallActionStatus.values, status);
    switch(actionStatus) {

      case CallActionStatus.ON_CALL:
      case CallActionStatus.CALL_START:
      case CallActionStatus.OFFER_SDP:
      case CallActionStatus.OFFER_SDP_RECEIVED:
      case CallActionStatus.ANSWER_SDP:
      case CallActionStatus.ANSWER_SDP_RECEIVED:
      case CallActionStatus.CALLER_CANDIDATE:
      case CallActionStatus.CALLER_CANDIDATE_RECEIVED:
      case CallActionStatus.RECEIVER_CANDIDATE:
      case CallActionStatus.RECEIVER_CANDIDATE_RECEIVED:
      case CallActionStatus.RECEIVER_HANG_UP:
      case CallActionStatus.RECEIVER_ENDED_CALL:
      case CallActionStatus.ANSWER_CALL:
      case CallActionStatus.SET_CANDIDATE:
      case CallActionStatus.END_CALL:
      case CallActionStatus.RECEIVER_REJECT:
      case CallActionStatus.CALLER_HANG_UP:
      case CallActionStatus.CALLER_HANG_ENDED_CALL:

        return themeData!.textTheme.bodyLarge!.copyWith( fontSize: Get.width * 0.045423);
      case CallActionStatus.CALLER_HANG_UP_AFTER_NO_ANSWER:

      return themeData!.textTheme.bodyLarge!.copyWith(color: Colors.red, fontSize: Get.width * 0.045423);

        default:
          return themeData!.textTheme.bodyLarge!.copyWith( fontSize: Get.width * 0.045423);
    }
  }

  Widget callVideoVoice(String call) {
    CallType? callType = EnumToString.fromString(CallType.values, call);
    switch (callType) {
      case CallType.VOICE_CALL:
        return const Icon(Icons.call);
      case CallType.VIDEO_CALL:
        return const Icon(Icons.video_call);
      default:
        return Container();
    }
  }
}
class CallTimeStamp{
  Timestamp timestamp;
  final now = DateTime.now();

  CallTimeStamp(this.timestamp);

  time(){
    final fifteenAgo = DateTime.now().subtract(Duration(minutes: timestamp.toDate().minute));

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final threeDaysAgo = DateTime(now.year, now.month, now.day - 2);
    final fourDaysAgo = DateTime(now.year, now.month, now.day - 3);
    // return DateFormat.jms().format(timestamp.toDate()) == 9:30 AM;
    // return DateFormat.MEd().format(timestamp.toDate()) == Sat, 11/25;
    // return DateFormat.M().format(timestamp.toDate()) == 11;
    // return DateFormat.Md().format(timestamp.toDate()) == 11/23;
    // return DateFormat.MMM().format(yesterday) == Nov;
    // return DateFormat.MMMd().format(yesterday) == Nov 26;
    // return DateFormat.MMMMEEEEd().format(yesterday) Friday Novembe 26;
    // return DateFormat.EEEE().format(yesterday) == Friday;
    // return DateFormat.E().format(yesterday) == Fri;
    // return DateFormat.MMMMd().format(yesterday) == Novenber 26;
    // return DateFormat.jm().format(timestamp.toDate()) 9:13 PM;
    // print("Today ${timestamp.toDate().day - 1 == today.day}");
    if(timestamp.toDate().day == today.day && timestamp.toDate().year == today.year) return DateFormat.jm().format(timestamp.toDate());
    if(timestamp.toDate().day  == today.day -1 && timestamp.toDate().year == today.year) return "Yesterday ${DateFormat.jm().format(timestamp.toDate())}";
    if(timestamp.toDate().day   == today.day - 2 && timestamp.toDate().year == today.year) return "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
    if(timestamp.toDate().day   == today.day - 3 && timestamp.toDate().year == today.year) return "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
    if(timestamp.toDate().day   == today.day - 4 && timestamp.toDate().year == today.year) return "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
    if(timestamp.toDate().day   == today.day - 5 && timestamp.toDate().year == today.year) return "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
    if(timestamp.toDate().day   == today.day - 6 && timestamp.toDate().year == today.year) return "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
    if(timestamp.toDate().day   == today.day - 7 && timestamp.toDate().year == today.year) return "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
    return  "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
  }
}
