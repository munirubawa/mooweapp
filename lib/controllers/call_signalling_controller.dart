import 'package:mooweapp/export_files.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

// typedef StreamStateCallback = void Function(MediaStream stream);

class CallSignalingController extends GetxController {
  static CallSignalingController instance = Get.find();

  DocumentSnapshot? callActionDetailsSnapshot;
  Map<String, dynamic> callActionDetailsData = {};
  // DocumentReference? callLDocReference;

  Rx<IncomingCallOrOutGoingCall> callDirection = IncomingCallOrOutGoingCall.OUTGOING_CALL.obs;
  RxBool showCallButtons = true.obs;
  RxBool volumeMuted = false.obs;
  RxBool flipScreens = false.obs;
  RxBool inCall = false.obs;
  Rx<RTCPeerConnectionState> connectionState = RTCPeerConnectionState.RTCPeerConnectionStateNew.obs;
  Rx<CallActionStatus> screenStatus = CallActionStatus.CALL_START.obs;
  Rx<CallType> screenCallType = CallType.VOICE_CALL.obs;

  // RTCPeerConnection? peerConnection;
  // MediaStream? _localStream;
  // RTCVideoRenderer localRenderer = RTCVideoRenderer();
  // RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  // MediaStream? _remoteStream;
  @override
  void onInit() {
    // checkPermission();
    ever(connectionState, (callback) => printConnection());
    ever(screenStatus, (callback) => callConnection());
    super.onInit();
  }

  void printConnection() {
    if (kDebugMode) {
      print("connectionStateconnectionState");
    }
    if (kDebugMode) {
      print(connectionState);
    }
    // signalingController.callActionDetails!.reference.update({
    //   callActionDetailsModel.callActionStatus: EnumToStrinconvertToString(connectionState.value),
    // });
  }

  void flipScreen() {
    flipScreens.value = !flipScreens.value;
  }

  void showCallScreen(IncomingCallOrOutGoingCall inOrOutCall) {
    callDirection.value = inOrOutCall;
    switch (inOrOutCall) {
      case IncomingCallOrOutGoingCall.INCOMING_CALL:
        FirebaseFirestore.instance.doc(incomingCallPath!).get().then((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            screenCallType.value = EnumToString.fromString(CallType.values, snapshot.get(callActionDetailsModel.callType))!;

            callActionDetailsSnapshot = snapshot;
            callListener(snapshot);
            // Get.to(() => VideoAndAudioCallingScreen());
            Get.to(() => WebRtcVideoCall());
            // Get.to(() => WebRtcVideoCall(
            //       localRenderer: _localRenderer,
            //       remoteRenderer: _remoteRenderer,
            //     ));
          }
        });

        // localRenderer.initialize().then((value) {
        //   remoteRenderer.initialize().then((value) {
        //     _createPeerConnection().then((pc) {
        //       peerConnection = pc;
        //       registerPeerConnectionListeners();
        //
        //       navController.callStatus.value = CallActionStatus.CALL_START;
        //       screenStatus.value = CallActionStatus.CALL_START;
        //
        //     });
        //   });
        // });

        break;
      case IncomingCallOrOutGoingCall.OUTGOING_CALL:

        screenCallType.value = EnumToString.fromString(CallType.values, callActionDetailsData[callActionDetailsModel.callType])!;
        callActionDetailsData[callActionDetailsModel.callFrom][memberModel.deviceToken] = deviceToken.value;
        navController.callStatus.value = CallActionStatus.CALL_START;
        screenStatus.value = CallActionStatus.CALL_START;
        callActionDetailsData[callActionDetailsModel.time] = Timestamp.now();
        firebaseFirestore.collection("rooms").add(callActionDetailsData).then((value) {
          value.get().then((event) {
            if (event.exists) {
              callActionDetailsSnapshot = event;
              callListener(callActionDetailsSnapshot!);
              // Get.to(() => VideoAndAudioCallingScreen());
              Get.to(() => WebRtcVideoCall());

              // Get.to(() => WebRtcVideoCall(
              //       localRenderer: _localRenderer,
              //       remoteRenderer: _remoteRenderer,
              //     ));
              // createRoom();
            }
          });
        });
        // localRenderer.initialize().then((value) {
        //   remoteRenderer.initialize().then((value) {
        //     _createPeerConnection().then((pc) {
        //       peerConnection = pc;
        //       registerPeerConnectionListeners();
        //
        //     });
        //   });
        // });

        break;
    }
  }

  void callListener(DocumentSnapshot snapshot) {
    snapshot.reference.snapshots().listen((event) {
      if (kDebugMode) {
        print(event.data());
      }

      if (event.exists == true && event.get(callActionDetailsModel.callActionStatus) != null) {
        screenStatus.value = EnumToString.fromString(CallActionStatus.values, event.get(callActionDetailsModel.callActionStatus))!;

        switch (callDirection.value) {
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            break;
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            break;
        }
      }
    });
  }

  void callConnection() async {
    switch (screenStatus.value) {
      case CallActionStatus.CALL_START:
        Future.delayed(const Duration(seconds: 1), () {
          // callActionDetailsSnapshot?.reference.update({
          //   callActionDetailsModel.callActionStatus: EnumToString.convertToString(CallActionStatus.SET_CANDIDATE),
          // });
        });
        switch (callDirection.value) {
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            break;
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            // await peerConnection!.setLocalDescription(offer);

            break;
        }
        break;
      case CallActionStatus.OFFER_SDP:
        switch (callDirection.value) {
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            break;
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            break;
        }
        break;
      case CallActionStatus.OFFER_SDP_RECEIVED:
        switch (callDirection.value) {
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            break;
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            break;
        }
        break;
      case CallActionStatus.ANSWER_SDP:
        switch (callDirection.value) {
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            break;
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            break;
        }
        break;
      case CallActionStatus.ANSWER_SDP_RECEIVED:
        switch (callDirection.value) {
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            break;
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            break;
        }
        break;
      case CallActionStatus.CALLER_CANDIDATE:
        switch (callDirection.value) {
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            break;
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            break;
        }
        break;
      case CallActionStatus.CALLER_CANDIDATE_RECEIVED:
        switch (callDirection.value) {
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            break;
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            break;
        }
        break;
      case CallActionStatus.RECEIVER_CANDIDATE:
        switch (callDirection.value) {
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            break;
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            break;
        }
        break;

      case CallActionStatus.RECEIVER_CANDIDATE_RECEIVED:
      case CallActionStatus.ANSWER_CALL:
      case CallActionStatus.SET_CANDIDATE:
      case CallActionStatus.END_CALL:
      case CallActionStatus.CALLER_HANG_UP:
      case CallActionStatus.CALLER_HANG_UP_AFTER_NO_ANSWER:
      case CallActionStatus.CALLER_HANG_ENDED_CALL:
      case CallActionStatus.RECEIVER_HANG_UP:
      case CallActionStatus.RECEIVER_ENDED_CALL:
      case CallActionStatus.RECEIVER_REJECT:
        // TODO: Handle this case.
        break;
      case CallActionStatus.ON_CALL:
        switch (callDirection.value) {
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            //      List<dynamic> candida = callActionDetails!.get(callActionDetailsModel.callerCandidate);
            // Future.delayed(const Duration(seconds: 2), (){
            //   for (var document in candida) {
            //     var data = document;
            //     // print(data);
            //     // print('Got new remote ICE candidate document: $data');
            //     peerConnection!.addCandidate(
            //       RTCIceCandidate(
            //         document['candidate'],
            //         document['sdpMid'],
            //         document['sdpMLineIndex'],
            //       ),
            //     );
            //   }
            // });
            // callActionDetails.reference.collection('callerCandidates').snapshots().listen((snapshot) {
            //
            // });
            break;
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            break;
        }

        break;
    }
  }

  void hangUp() {

  }

  void sendNotification() {
    print(callActionDetailsData[callActionDetailsModel.callTo][memberCallInfoModel.deviceToken]);
    AssistantMethods.sendANotification(
      title: "Incoming Video Call",
      body: "Call from ${callActionDetailsData[callActionDetailsModel.callFrom][memberCallInfoModel.firstName]}",
      token: callActionDetailsData[callActionDetailsModel.callTo][memberCallInfoModel.deviceToken],
      notificationType: EnumToString.convertToString(NotificationDataType.CALL_DATA),
      notificationDocPath: callActionDetailsSnapshot!.reference.path,
      extraData: callActionDetailsData,
    );
  }

  bool remoteDescriptionIsSet = false;
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': ['stun:stun1.l.google.com:19302', 'stun:stun2.l.google.com:19302']
      }
    ]
  };

  final Map<String, dynamic> offerSdpConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": [],
  };
  bool isAnswerSet = false;

  sendSignalStatusUpdate({int sec = 30, required CallActionStatus status}) {
    Future.delayed(Duration(milliseconds: sec), () {
      signal.callActionDetailsSnapshot!.reference.update({
        callActionDetailsModel.callActionStatus: EnumToString.convertToString(status),
      });
    });
  }


  bool isOfferSet = false;


  String? incomingCallPath;
  Timer? _timer;
  final int _start = 12;
  final int? _seconds = 5;
  bool timerRunning = false;

  setState(Function() state) {
    state();
    update();
  }

  void showToast(String message, {Toast duration = Toast.LENGTH_LONG, ToastGravity gravity = ToastGravity.CENTER}) {
    Fluttertoast.showToast(msg: message, toastLength: duration, gravity: gravity, timeInSecForIosWeb: 3, backgroundColor: Colors.grey, textColor: Colors.black, fontSize: 16.0);
  }

  @override
  void onClose() {
    // assetAudioPlayerRingBackTone.dispose();
  }
}
