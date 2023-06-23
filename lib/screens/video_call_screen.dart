import 'package:mooweapp/export_files.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
typedef StreamStateCallback = void Function(MediaStream stream);


class WebRtcVideoCall extends StatefulWidget {
  WebRtcVideoCall({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WebRtcVideoCall> {
  bool _offer = false;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
webrtc.RTCRtpSender? sender;
  bool callConnected = false;
  StreamStateCallback? onAddRemoteStream;

  @override
  dispose() {
    navController.callStatus.value = CallActionStatus.END_CALL;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    // Wakelock.disable();
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    NotificationController.cancelNotifications();
    callActions();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // signalingController.callActionDetailsSnapshot = signalingController.callActionDetailsSnapshot;
    initRenderers().then((value) {
      _createPeerConnecion().then((pc) {
        _peerConnection = pc;
        switch (signal.callDirection.value) {
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            _createOffer();
            break;
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            _createAnswer();
            break;
        }
      });
    });
    onAddRemoteStream = ((stream){
      remoteRenderer.srcObject = stream;
      setState(() {
      });
    });

    signal.showCallButtons.value = true;
    // signal.connectionState.listen((RTCPeerConnectionState state) {
    //   switch (state) {
    //     case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
    //     case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
    //     case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
    //     case RTCPeerConnectionState.RTCPeerConnectionStateNew:
    //       break;
    //     case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
    //       // TODO: Handle this case.
    //       break;
    //     case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
    //       callConnected = true;
    //       signal.showCallButtons.value = false;
    //       break;
    //   }
    // });

    super.initState();
  }

  _createPeerConnecion() async {
    // Map<String, dynamic> configuration = {
    //   "iceServers": {
    //     "urls": serverList
    //   }
    // };
    Map<String, dynamic> configuration = {
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
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

    _localStream = await _getUserMedia();

    _peerConnection = await createPeerConnection(configuration);

    _localStream?.getTracks().forEach((MediaStreamTrack track) => {
      _peerConnection?.addTrack(track, _localStream!).then((value) => sender = value)
    });

    _peerConnection?.onAddTrack = (MediaStream stream, MediaStreamTrack track) => {_localStream?.addTrack(track)};
    _peerConnection?.onConnectionState = (RTCPeerConnectionState connectionState) {
      print("ConnectionState:  connection");
      debugPrint(connectionState.toString());
      // setState(() {});
    };
    _peerConnection?.onIceConnectionState = (e) {
      print("gotonIceConnection");
      print(e);
    };

    _peerConnection?.onAddStream = (stream) {
      print('addStreampc.onAddStream: ${stream.id}');
      remoteRenderer.srcObject = stream;
    };
    _peerConnection?.onAddStream = (stream) {
      print('onAddStream ${stream.id}');
    };

    return _peerConnection;
  }

  _getUserMedia() async {
    final Map<String, dynamic> constraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    };

    MediaStream stream = await webrtc.navigator.mediaDevices.getUserMedia(constraints);

    localRenderer.srcObject = stream;
    _localStream = stream;
    // _localRenderer.mirror = true;
    return stream;
  }

  void hangUp() async {
    print("hangUp");
    _localStream?.getTracks().forEach((MediaStreamTrack track)  {
      track.stop();
    });
    if(_remoteStream != null) {
      _remoteStream?.getTracks().forEach((MediaStreamTrack track) {
        track.stop();
      });
    }
    _peerConnection?.removeTrack(sender!);
    _peerConnection?.close();
    _localStream?.dispose();
    _remoteStream?.dispose();
    // Get.back();
  }
  void _createOffer() async {
    // RTCSessionDescription description = await _peerConnection!.createOffer({'offerToReceiveVideo': 1});

    _peerConnection!.createOffer().then((RTCSessionDescription description) {
      var session = parse(description.sdp.toString());
      print(json.encode(session));
      _offer = true;
      print("_createOffer");
      _peerConnection?.setLocalDescription(description).then((value) {});

      signal.callActionDetailsSnapshot!.reference.collection("answer").snapshots().listen((event) {
        for (var doc in event.docs) {
          if (doc.exists) {
            Map<String, dynamic> data = event.docs.first.data();
            _peerConnection?.setRemoteDescription(RTCSessionDescription(data["answer"]["sdp"], data["answer"]["type"]));
          }
        }
      });

      signal.callActionDetailsSnapshot!.reference.collection("offer").add({
        "offer": {"sdp": description.sdp, "type": "offer"}
      });
      // signal.callActionDetailsSnapshot!.reference.update({
      //   "offer": {"sdp": description.sdp.toString(), "type": "offer"}
      // });
      _peerConnection?.onIceCandidate = (event) {
        debugPrint("${event.toMap()}");
        signal.callActionDetailsSnapshot!.reference.collection("offerIceCandidate").add(event.toMap());
      };
      signal.callActionDetailsData[callActionDetailsModel.time] = "";
      signal.sendNotification();
    });
    signal.callActionDetailsSnapshot!.reference.collection("answerIceCandidate").snapshots().listen((event) {
      for (var doc in event.docs) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data();
          print("answerIceCandidate data");
          print(data);
          _peerConnection?.addCandidate(RTCIceCandidate(data["candidate"], data["sdpMid"], data["sdpMLineIndex"]));
        }
      }
    });
    Future.delayed(const Duration(seconds: 1), () {});
    // print(json.encode({
    //       'sdp': description.sdp.toString(),
    //       'type': description.type.toString(),
    //     }));

    // _peerConnection!.setLocalDescription(description);
    // setState(() {});
    // signal.callActionDetailsSnapshot!.reference.update({
    //   "offer": {"sdp": json.encode(session), "type": "offer"}
    // });
  }

  void _createAnswer() async {
    // RTCSessionDescription description = await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});
    _peerConnection?.createAnswer().then((RTCSessionDescription answer) {
      _peerConnection?.setLocalDescription(answer).then((value) {
        signal.callActionDetailsSnapshot!.reference.collection("answer").add({
          "answer": {"sdp": answer.sdp, "type": "answer"}
        });
      });
    });
    signal.callActionDetailsSnapshot!.reference.collection("offer").snapshots().listen((event) {
      // debugPrint("${event.docs.first.data()}");
      for (var doc in event.docs) {
        debugPrint("answer created");
        Map<String, dynamic> data = event.docs.first.data();
        if (doc.exists) {
          print(data);
          _peerConnection?.setRemoteDescription(RTCSessionDescription(data["offer"]["sdp"], data["offer"]["type"]));
        }
      }
    });
    _peerConnection?.onIceCandidate = (event) {
      debugPrint("${event.toMap()}");
      signal.callActionDetailsSnapshot!.reference.collection("answerIceCandidate").add(event.toMap());
    };
  }

  // TODO end of WebRtc implementation

  void callActions() {
    Future.delayed(const Duration(seconds: 30), () {
      if (!callConnected) {}
    });
  }

  Future initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    setState(() {});
    switch (signal.callDirection.value) {
      case IncomingCallOrOutGoingCall.INCOMING_CALL:
        break;
      case IncomingCallOrOutGoingCall.OUTGOING_CALL:
        Future.delayed(const Duration(seconds: 1), () {});
        break;
    }
    return Future.value(null);
  }

  @override
  Widget build(BuildContext context) {
    return PIPView(builder: (context, isFloating) {
      return WillPopScope(
        onWillPop: () async {
          navController.pipContext = context;

          if (navController.callStatus.value == CallActionStatus.CALL_START) {
            navController.smallScreen();
            return false;
          } else {
            return true;
          }
        },

        child: Scaffold(
          body: OrientationBuilder(
            builder: (context, orientation) {
              return Obx(() {
                switch (signal.screenStatus.value) {
                  case CallActionStatus.END_CALL:
                    navController.callStatus.value = CallActionStatus.END_CALL;
                    return screenOverLay();
                  case CallActionStatus.CALLER_HANG_ENDED_CALL:
                    navController.callStatus.value = CallActionStatus.END_CALL;
                    switch (signal.callDirection.value) {
                      case IncomingCallOrOutGoingCall.INCOMING_CALL:
                        hangUp();
                        Future.delayed(const Duration(seconds: 1), () {
                          Get.back();
                        });
                        break;
                      case IncomingCallOrOutGoingCall.OUTGOING_CALL:
                        break;
                    }
                    return screenOverLay();
                  case CallActionStatus.RECEIVER_ENDED_CALL:
                    navController.callStatus.value = CallActionStatus.END_CALL;
                    switch (signal.callDirection.value) {
                      case IncomingCallOrOutGoingCall.INCOMING_CALL:
                        break;
                      case IncomingCallOrOutGoingCall.OUTGOING_CALL:
                        hangUp();
                        Future.delayed(const Duration(seconds: 1), () {
                          Get.back();
                        });
                        break;
                    }
                    return screenOverLay();
                  case CallActionStatus.CALLER_HANG_UP:
                    navController.callStatus.value = CallActionStatus.END_CALL;
                    switch (signal.callDirection.value) {
                      case IncomingCallOrOutGoingCall.INCOMING_CALL:
                        hangUp();
                        Future.delayed(const Duration(seconds: 1), () {
                          Get.back();
                        });
                        break;
                      case IncomingCallOrOutGoingCall.OUTGOING_CALL:
                        break;
                    }
                    return screenOverLay();
                  case CallActionStatus.CALLER_HANG_UP_AFTER_NO_ANSWER:
                    hangUp();
                    navController.callStatus.value = CallActionStatus.END_CALL;
                    switch (signal.callDirection.value) {
                      case IncomingCallOrOutGoingCall.INCOMING_CALL:
                        Future.delayed(const Duration(seconds: 1), () {
                          Get.back();
                        });
                        break;
                      case IncomingCallOrOutGoingCall.OUTGOING_CALL:
                        break;
                    }
                    return screenOverLay();
                  case CallActionStatus.RECEIVER_HANG_UP:
                    hangUp();
                    navController.callStatus.value = CallActionStatus.END_CALL;
                    switch (signal.callDirection.value) {
                      case IncomingCallOrOutGoingCall.INCOMING_CALL:
                        break;
                      case IncomingCallOrOutGoingCall.OUTGOING_CALL:
                        Future.delayed(const Duration(seconds: 1), () {
                          Get.back();
                        });
                        break;
                    }
                    return screenOverLay();
                  case CallActionStatus.RECEIVER_REJECT:
                    navController.callStatus.value = CallActionStatus.END_CALL;
                    switch (signal.callDirection.value) {
                      case IncomingCallOrOutGoingCall.INCOMING_CALL:
                        break;
                      case IncomingCallOrOutGoingCall.OUTGOING_CALL:
                        hangUp();
                        signal.showToast("Call Rejected", gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);

                        Future.delayed(const Duration(seconds: 2), () {
                          Get.back();
                        });
                        break;
                    }
                    return screenOverLay();

                  case CallActionStatus.OFFER_SDP_RECEIVED:
                  case CallActionStatus.ANSWER_SDP_RECEIVED:
                  case CallActionStatus.CALLER_CANDIDATE:
                  case CallActionStatus.CALLER_CANDIDATE_RECEIVED:
                  case CallActionStatus.RECEIVER_CANDIDATE:
                  case CallActionStatus.RECEIVER_CANDIDATE_RECEIVED:
                  case CallActionStatus.OFFER_SDP:
                  case CallActionStatus.ANSWER_SDP:
                  case CallActionStatus.SET_CANDIDATE:
                  case CallActionStatus.CALL_START:
                    // signalingController.update();
                    switch (signal.screenCallType.value) {
                      case CallType.VOICE_CALL:
                        // TODO: Handle this case.
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            audioCall(),
                            Obx(() => signal.showCallButtons.value == true ? liveCallActionButtons() : Container()),
                          ],
                        );
                      case CallType.VIDEO_CALL:
                        // TODO: Handle this case.
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            _localFullScree(),
                            _callerDetails(),
                            Obx(() => signal.showCallButtons.value == true ? liveCallActionButtons() : Container()),
                          ],
                        );
                    }

                  // case CallActionStatus.RTCPeerConnectionStateClosed:
                  // case CallActionStatus.RTCPeerConnectionStateFailed:
                  // case CallActionStatus.RTCPeerConnectionStateDisconnected:
                  // case CallActionStatus.RTCPeerConnectionStateNew:
                  // case CallActionStatus.RTCPeerConnectionStateConnecting:
                  // case CallActionStatus.RTCPeerConnectionStateConnected:
                  case CallActionStatus.ON_CALL:
                  case CallActionStatus.ANSWER_CALL:
                    switch (signal.screenCallType.value) {
                      case CallType.VOICE_CALL:
                        // TODO: Handle this case.
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            audioCall(),
                            Obx(() => signal.showCallButtons.value == true ? liveCallActionButtons() : Container()),
                          ],
                        );
                      case CallType.VIDEO_CALL:
                        // TODO: Handle this case.
                        return InkWell(
                          onTap: () {
                            signal.showCallButtons.value = !signal.showCallButtons.value;
                            if (signal.showCallButtons.value) {
                              Future.delayed(const Duration(seconds: 3), () {
                                signal.showCallButtons.value = !signal.showCallButtons.value;
                              });
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _remoteVideoFeed(),
                              _localVideoFeed(),
                              Obx(() => signal.showCallButtons.value == true ? liveCallActionButtons() : Container()),
                              Positioned(
                                  top: 20,
                                  left: 25,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      navController.callStatus.value = CallActionStatus.CALL_START;
                                      navController.pipContext = context;
                                      navController.smallScreen();
                                    },
                                  )),
                            ],
                          ),
                        );
                    }
                }
              });
            },
          ),
        ),
      );
    });
  }

  Widget screenOverLay() {
    switch (signal.screenCallType.value) {
      case CallType.VIDEO_CALL:
        return Stack(
          alignment: Alignment.center,
          children: [
            _localFullScree(),
          ],
        );
      case CallType.VOICE_CALL:
        // TODO: Handle this case.
        return audioCall();
    }
  }

  Widget audioCall() {
    switch (signal.callDirection.value) {
      case IncomingCallOrOutGoingCall.INCOMING_CALL:
        // TODO: Handle this case.
        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: Get.width,
              height: Get.height,
              child: storage.checkImage(
                signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callFrom)[memberCallInfoModel.imageUrl].toString(),
              )
                  ? ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: storage.getImage(
                                signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callFrom)[memberCallInfoModel.imageUrl].toString(),
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: storage.networkImage(signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callFrom)[memberCallInfoModel.imageUrl].toString(),
                          shape: BoxShape.rectangle, fit: BoxFit.cover),
                    ),
            ),
          ),
        );
      case IncomingCallOrOutGoingCall.OUTGOING_CALL:
        // TODO: Handle this case.
        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: Get.width,
              height: Get.height,
              child: storage.checkImage(
                signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callTo)[memberCallInfoModel.imageUrl].toString(),
              )
                  ? ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: storage.getImage(
                                signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callTo)[memberCallInfoModel.imageUrl].toString(),
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: storage.networkImage(signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callTo)[memberCallInfoModel.imageUrl].toString(),
                          shape: BoxShape.rectangle, fit: BoxFit.cover),
                    ),
            ),
          ),
        );
    }
  }

  Widget _callerDetails() {
    switch (signal.callDirection.value) {
      case IncomingCallOrOutGoingCall.INCOMING_CALL:
        return Positioned(
          top: 65,
          child: Column(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: storage.checkImage(
                  signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callFrom)[memberCallInfoModel.imageUrl].toString(),
                )
                    ? ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: storage.getImage(
                                  signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callFrom)[memberCallInfoModel.imageUrl].toString(),
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        child: storage.networkImage(signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callFrom)[memberCallInfoModel.imageUrl].toString(),
                            shape: BoxShape.rectangle, fit: BoxFit.cover),
                      ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "${signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callFrom)[memberCallInfoModel.firstName]} " +
                    signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callFrom)[memberCallInfoModel.lastName],
                style: themeData!.textTheme.headline5!.copyWith(color: Colors.white),
              )
            ],
          ),
        );
      case IncomingCallOrOutGoingCall.OUTGOING_CALL:
        return Positioned(
          top: 65,
          child: Column(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: storage.checkImage(
                  signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callTo)[memberCallInfoModel.imageUrl].toString(),
                )
                    ? ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: storage.getImage(
                                  signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callTo)[memberCallInfoModel.imageUrl].toString(),
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        child: storage.networkImage(signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callTo)[memberCallInfoModel.imageUrl].toString(),
                            shape: BoxShape.rectangle, fit: BoxFit.cover),
                      ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "${signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callTo)[memberCallInfoModel.firstName]} " +
                    signal.callActionDetailsSnapshot!.get(callActionDetailsModel.callTo)[memberCallInfoModel.lastName],
                style: themeData!.textTheme.headline5!.copyWith(color: Colors.white),
              )
            ],
          ),
        );
    }
  }

  Widget _localFullScree() {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: localRenderer.videoWidth.toDouble(),
          height: localRenderer.videoHeight.toDouble(),
          child: RTCVideoView(localRenderer),
        ),
      ),
    );
  }

  Widget _remoteVideoFeed() {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: localRenderer.videoWidth.toDouble(),
          height: localRenderer.videoHeight.toDouble(),
          child: Obx(() {
            return signal.flipScreens.value == false ? RTCVideoView(remoteRenderer, mirror: true) : RTCVideoView(localRenderer);
          }),
        ),
      ),
    );
  }

  Widget _localVideoFeed() {
    return Positioned(
      top: 15,
      right: 20,
      child: InkWell(
        onTap: () {
          signal.flipScreen();
        },
        child: Container(
          key: const Key("local"),
          margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          width: MediaQuery.of(context).size.width * 0.20,
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: const BoxDecoration(color: Colors.black54),
          child: SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: localRenderer.videoWidth.toDouble(),
                height: localRenderer.videoHeight.toDouble(),
                child: Obx(() {
                  return signal.flipScreens.value == false ? RTCVideoView(localRenderer) : RTCVideoView(remoteRenderer, mirror: true);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget liveCallActionButtons() {
    TextStyle style = themeData!.textTheme.bodyText2!.copyWith(color: Colors.white);

    switch (signal.screenStatus.value) {
      case CallActionStatus.OFFER_SDP_RECEIVED:
      case CallActionStatus.ANSWER_SDP_RECEIVED:
      case CallActionStatus.CALLER_CANDIDATE:
      case CallActionStatus.CALLER_CANDIDATE_RECEIVED:
      case CallActionStatus.RECEIVER_CANDIDATE:
      case CallActionStatus.RECEIVER_CANDIDATE_RECEIVED:
      case CallActionStatus.OFFER_SDP:
      case CallActionStatus.ANSWER_SDP:
      case CallActionStatus.CALLER_HANG_ENDED_CALL:
      case CallActionStatus.RECEIVER_ENDED_CALL:
      case CallActionStatus.SET_CANDIDATE:
      case CallActionStatus.END_CALL:
      case CallActionStatus.CALLER_HANG_UP:
      case CallActionStatus.CALLER_HANG_UP_AFTER_NO_ANSWER:
      case CallActionStatus.RECEIVER_HANG_UP:
      case CallActionStatus.RECEIVER_REJECT:
      case CallActionStatus.CALL_START:
        switch (signal.callDirection.value) {
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            return hangUpOrPickUp();
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            return hangupButtons();
        }

      // case CallActionStatus.RTCPeerConnectionStateClosed:
      // case CallActionStatus.RTCPeerConnectionStateFailed:
      // case CallActionStatus.RTCPeerConnectionStateDisconnected:
      // case CallActionStatus.RTCPeerConnectionStateNew:
      // case CallActionStatus.RTCPeerConnectionStateConnecting:
      // case CallActionStatus.RTCPeerConnectionStateConnected:

      case CallActionStatus.ON_CALL:
      case CallActionStatus.ANSWER_CALL:
        switch (signal.callDirection.value) {
          case IncomingCallOrOutGoingCall.INCOMING_CALL:
            return Positioned(bottom: 50, child: connectedButtons());
          case IncomingCallOrOutGoingCall.OUTGOING_CALL:
            return Positioned(bottom: 50, child: connectedButtons());
        }
    }
  }

  Widget hangUpOrPickUp() {
    return Positioned(
        bottom: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: "${DateTime.now().microsecondsSinceEpoch}",
              backgroundColor: Colors.red,
              onPressed: () {
                hangUp();
                signal.callActionDetailsSnapshot!.reference.update({
                  callActionDetailsModel.callActionStatus: EnumToString.convertToString(CallActionStatus.RECEIVER_REJECT),
                });
                Get.back();
              },
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 55,
            ),
            FloatingActionButton(
              heroTag: "${DateTime.now().microsecondsSinceEpoch}",
              backgroundColor: Colors.green,
              onPressed: () {
                signal.callActionDetailsSnapshot!.reference.update({
                  callActionDetailsModel.callActionStatus: EnumToString.convertToString(CallActionStatus.ON_CALL),
                });
              },
              child: const Icon(
                Icons.call,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  Widget hangupButtons() {
    return Positioned(
        bottom: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: "${DateTime.now().microsecondsSinceEpoch}",
              backgroundColor: Colors.red,
              onPressed: () {
                signal.callActionDetailsSnapshot!.reference.update({
                  callActionDetailsModel.callActionStatus: EnumToString.convertToString(CallActionStatus.CALLER_HANG_UP_AFTER_NO_ANSWER),
                });
                // Get.back();
                hangUp();
              },
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  Widget connectedButtons() {
    return Column(
      children: [
        SizedBox(
          width: Get.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: "${DateTime.now().microsecondsSinceEpoch}",
                backgroundColor: Colors.black.withOpacity(0.1),
                onPressed: () {
                  // hangUp();
                  // Get.back();
                },
                child: const Icon(
                  Icons.bluetooth_outlined,
                  color: Colors.white,
                ),
              ),
              FloatingActionButton(
                heroTag: "${DateTime.now().microsecondsSinceEpoch}",
                backgroundColor: Colors.black.withOpacity(0.1),
                onPressed: () {
                  signal.volumeMuted.value = !signal.volumeMuted.value;
                  localRenderer.muted = signal.volumeMuted.value;

                  localRenderer.srcObject?.getAudioTracks()[0].onMute = () {
                    print("volume onMute");
                    print(signal.volumeMuted.value);
                  };
                  localRenderer.srcObject?.getAudioTracks()[0].onUnMute = () {
                    print("volume onUnMute");
                    print(signal.volumeMuted.value);
                  };
                  print("_localRenderer.muted");
                },
                child: Obx(() {
                  return signal.volumeMuted.value == true
                      ? const Icon(
                          Icons.volume_off,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.volume_up_outlined,
                          color: Colors.white,
                        );
                }),
              ),
              FloatingActionButton(
                heroTag: "${DateTime.now().microsecondsSinceEpoch}",
                backgroundColor: Colors.black.withOpacity(0.1),
                onPressed: () {
                  // if (widget.localRenderer.value != null) {
                  //   Helper.switchCamera(_localStream!.getVideoTracks()[0]);
                  // }
                },
                child: const Icon(
                  Icons.switch_camera_outlined,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            FloatingActionButton(
              heroTag: "${DateTime.now().microsecondsSinceEpoch}",
              backgroundColor: Colors.red,
              onPressed: () {
                navController.callStatus.value = CallActionStatus.END_CALL;
                switch (signal.callDirection.value) {
                  case IncomingCallOrOutGoingCall.INCOMING_CALL:
                    signal.callActionDetailsSnapshot!.reference.update({
                      callActionDetailsModel.callActionStatus: EnumToString.convertToString(CallActionStatus.RECEIVER_ENDED_CALL),
                    });
                    break;
                  case IncomingCallOrOutGoingCall.OUTGOING_CALL:
                    signal.callActionDetailsSnapshot!.reference.update({
                      callActionDetailsModel.callActionStatus: EnumToString.convertToString(CallActionStatus.CALLER_HANG_ENDED_CALL),
                    });
                    break;
                }
                // hangUp();
                Get.back();
              },
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }
}
