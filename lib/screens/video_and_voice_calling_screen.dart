import 'package:mooweapp/export_files.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

class VideoAndAudioCallingScreen extends StatefulWidget {
  VideoAndAudioCallingScreen({
    Key? key,
  }) : super(key: key);

  @override
  _VideoAndAudioCallingScreenState createState() => _VideoAndAudioCallingScreenState();
}

class _VideoAndAudioCallingScreenState extends State<VideoAndAudioCallingScreen> {
  bool _offer = false;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  final sdpController = TextEditingController();

  @override
  dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initRenderer();
    _createPeerConnecion().then((pc) {
      _peerConnection = pc;
      switch(signal.callDirection.value) {
        case IncomingCallOrOutGoingCall.OUTGOING_CALL:
          _createOffer();
          break;
        case IncomingCallOrOutGoingCall.INCOMING_CALL:
          _createAnswer();
          break;

      }
    });
    // _getUserMedia();
    super.initState();
  }

  initRenderer() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    setState(() {});
  }

  _createPeerConnecion() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        // {"url": "stun2.l.google.com:19302"},
        {"url": "stun:stun.l.google.com:19302"},
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

    _peerConnection?.onAddTrack = (MediaStream stream, MediaStreamTrack track) => {
      _localStream?.addTrack(track)

    };
    _peerConnection?.onConnectionState = (RTCPeerConnectionState connectionState){
      print("ConnectionState:  connection");
      debugPrint(connectionState.toString());
      setState(() {});

    };
    // switch (signal.callDirection.value) {
    //   case IncomingCallOrOutGoingCall.INCOMING_CALL:
    //     var snap = signal.callActionDetailsSnapshot!.reference.collection("receiverCandidate");
    //     _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
    //       print('Got candidate: receiverCandidate');
    //       print('Got candidate: ${candidate.toMap()}');
    //       snap.add(candidate.toMap());
    //     };
    //     break;
    //   case IncomingCallOrOutGoingCall.OUTGOING_CALL:
    //     var snap = signal.callActionDetailsSnapshot!.reference.collection("callerCandidate");
    //     _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
    //       print('Got candidate: callerCandidate');
    //       print('Got candidate: ${candidate.toMap()}');
    //       snap.add(candidate.toMap());
    //     };
    //     _peerConnection?.onIceCandidate = (e) {
    //       if (e.candidate != null) {
    //         print("gotonIceCandidate");
    //         print(json.encode({
    //           'candidate': e.candidate.toString(),
    //           'sdpMid': e.sdpMid.toString(),
    //           'sdpMlineIndex': e.sdpMLineIndex,
    //         }));
    //       }
    //     };
    //     break;
    // }

    _peerConnection?.onIceConnectionState = (e) {
      print("gotonIceConnection");
      print(e);
    };

    _peerConnection?.onAddStream = (stream) {
      print('addStreampc.onAddStream: ${stream.id}');
      _remoteRenderer.srcObject = stream;
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

    _localRenderer.srcObject = stream;
    // _localRenderer.mirror = true;

    return stream;
  }

  void _createOffer() async {
    // RTCSessionDescription description = await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
     _peerConnection!.createOffer().then((RTCSessionDescription description){
       var session = parse(description.sdp.toString());
       print(json.encode(session));
       _offer = true;
       print("_createOffer");

       signal.callActionDetailsSnapshot!.reference.collection("answer").snapshots().listen((event) {
         for (var doc in event.docs) {
           if(doc.exists) {
             Map<String, dynamic> data = event.docs.first.data();
              _peerConnection?.setRemoteDescription(RTCSessionDescription(data["answer"]["sdp"], data["answer"]["type"]));
           }
         }
       });

       _peerConnection?.setLocalDescription(description);
       signal.callActionDetailsSnapshot!.reference.collection("offer").add({"offer": {"sdp": description.sdp, "type": "offer"}});
       // signal.callActionDetailsSnapshot!.reference.update({
       //   "offer": {"sdp": description.sdp.toString(), "type": "offer"}
       // });
       _peerConnection?.onIceCandidate = (event)  {
         debugPrint("${event.toMap()}");
         signal.callActionDetailsSnapshot!.reference.collection("offerIceCandidate").add(event.toMap());
       };
       signal.callActionDetailsData[callActionDetailsModel.time] = "";
       signal.sendNotification();
     });
     signal.callActionDetailsSnapshot!.reference.collection("answerIceCandidate").snapshots().listen((event) {
       for (var doc in event.docs) {
         if(doc.exists) {
           Map<String, dynamic> data = doc.data();
           print("answerIceCandidate data");
           print(data);
           setState(() {});
           _peerConnection?.addCandidate(RTCIceCandidate(data["candidate"], data["sdpMid"], data["sdpMLineIndex"]));
         }
       }
     });
Future.delayed(Duration(seconds: 1), (){

});
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

    signal.callActionDetailsSnapshot!.reference.collection("offer").snapshots().listen((event) {
      // debugPrint("${event.docs.first.data()}");

      for (var doc in event.docs) {
        debugPrint("answer created");
          Map<String, dynamic> data = event.docs.first.data();
        if(doc.exists) {
          print(data);
          _peerConnection?.setRemoteDescription(RTCSessionDescription(data["offer"]["sdp"], data["offer"]["type"]));
          _peerConnection?.createAnswer().then((RTCSessionDescription answer){
            _peerConnection?.setLocalDescription(answer);
            signal.callActionDetailsSnapshot!.reference.collection("answer").add({"answer": {"sdp": answer.sdp, "type": "answer"}});

          });
        }
      }
    });
    _peerConnection?.onIceCandidate = (event)  {
      debugPrint("${event.toMap()}");
      signal.callActionDetailsSnapshot!.reference.collection("answerIceCandidate").add(event.toMap());
    };
   // _peerConnection!.createAnswer().then((RTCSessionDescription description){
   //
   // });
    Future.delayed(Duration(seconds: 1), (){

    });
    // var session = parse(description.sdp.toString());
    // print(json.encode(session));
    // // print(json.encode({
    // //       'sdp': description.sdp.toString(),
    // //       'type': description.type.toString(),
    // //     }));
    //
    // _peerConnection!.setLocalDescription(description);
    // setState(() {});
    // signal.callActionDetailsSnapshot!.reference.update({
    //   "answer": {"sdp": json.encode(session), "type": "answer"}
    // });
  }

  void _setRemoteDescription() async {
    switch (signal.callDirection.value) {
      case IncomingCallOrOutGoingCall.INCOMING_CALL:
        signal.callActionDetailsSnapshot!.reference.get().then((value) async {
          Map<String, dynamic> data = value.data() as Map<String, dynamic>;

          if (value.exists && data["offer"] != null) {
            dynamic session = await jsonDecode(data["offer"]["sdp"]);

            String sdp = write(session, null);

            print(data);
            RTCSessionDescription description = RTCSessionDescription(sdp, data["offer"]["type"]);
            print(description.toMap());

            await _peerConnection!.setRemoteDescription(description);
            setState(() {});
          }
        });
        break;
      case IncomingCallOrOutGoingCall.OUTGOING_CALL:
        signal.callActionDetailsSnapshot!.reference.get().then((value) async {
          Map<String, dynamic> data = value.data() as Map<String, dynamic>;

          if (value.exists && data["answer"] != null) {
            dynamic session = await jsonDecode(data["answer"]["sdp"]);

            String sdp = write(session, null);

            print(data);
            RTCSessionDescription description = RTCSessionDescription(sdp, data["answer"]["type"]);
            print(description.toMap());

            await _peerConnection!.setRemoteDescription(description);
            setState(() {});
          }
        });
        break;
    }
  }

  void _addCandidate() async {
    switch (signal.callDirection.value) {
      case IncomingCallOrOutGoingCall.INCOMING_CALL:
        // TODO: Handle this case.
        break;
      case IncomingCallOrOutGoingCall.OUTGOING_CALL:
        signal.callActionDetailsSnapshot!.reference.collection('receiverCandidate').get().then((snapshot) {
          snapshot.docChanges.forEach((element) {
            Map<String, dynamic> data = element.doc.data() as Map<String, dynamic>;
            print('Got new remote ICE candidate: ${jsonEncode(data)}');
            _peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
            setState(() {});
          });
        });
        break;
    }
    // String jsonString = sdpController.text;
    // dynamic session = await jsonDecode(jsonString);
    // print(session['candidate']);
    // dynamic candidate =
    // RTCIceCandidate(session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    // await _peerConnection!.addCandidate(candidate);
  }

  Future<void> hangUp() async {
    print("Hange up -------");
    navController.callStatus.value = CallActionStatus.END_CALL;
    List<MediaStreamTrack> tracks = _localRenderer.srcObject!.getTracks();
    // List<MediaStreamTrack> remoteTracks = _remoteRenderer.srcObject!.getTracks();
    tracks.forEach((track) {
      track.stop();
    });
    // remoteTracks.forEach((track) {
    //   track.stop();
    // });
    // isOfferSet = false;
    // isAnswerSet = false;
    signal.inCall.value = false;
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) => track.stop());
    }
    if (_peerConnection != null) _peerConnection!.close();

    var calleeCandidates = await signal.callActionDetailsSnapshot!.reference.collection('calleeCandidates').get();
    for (var document in calleeCandidates.docs) {
      document.reference.delete();
    }

    var callerCandidates = await signal.callActionDetailsSnapshot!.reference.collection('callerCandidates').get();
    for (var document in callerCandidates.docs) {
      document.reference.delete();
    }

    signal.callActionDetailsSnapshot!.reference.delete();

    // signalingController.connectionState.value = RTCPeerConnectionState.RTCPeerConnectionStateClosed;
    // _localRenderer.dispose();
    // _remoteRenderer.dispose();
    // signal.volumeMuted.value = false;
    // remoteDescriptionIsSet = false;
  }

  SizedBox videoRenderers() => SizedBox(
      height: 210,
      child: Row(children: [
        Flexible(
          child: Container(key: const Key("local"), margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0), decoration: const BoxDecoration(color: Colors.black), child: RTCVideoView(_localRenderer)),
        ),
        Flexible(
          child: Container(key: const Key("remote"), margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0), decoration: const BoxDecoration(color: Colors.black), child: RTCVideoView(_remoteRenderer)),
        )
      ]));

  Row offerAndAnswerButtons() => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        ElevatedButton(
          // onPressed: () {
          //   return showDialog(
          //       context: context,
          //       builder: (context) {
          //         return AlertDialog(
          //           content: Text(sdpController.text),
          //         );
          //       });
          // },
          onPressed: _createOffer,
          child: const Text('Offer'),
          // color: Colors.amber,
        ),
        ElevatedButton(
          onPressed: _createAnswer,
          style: ElevatedButton.styleFrom(primary: Colors.amber),
          child: const Text('Answer'),
        ),
      ]);

  Row sdpCandidateButtons() => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        ElevatedButton(
          onPressed: _setRemoteDescription,
          child: const Text('Set Remote Desc'),
          // color: Colors.amber,
        ),
        ElevatedButton(
          onPressed: _addCandidate,
          child: const Text('Add Candidate'),
          // color: Colors.amber,
        )
      ]);

  Padding sdpCandidatesTF() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: sdpController,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          maxLength: TextField.noMaxLength,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              hangUp();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(""),
        ),
        body: Column(
          children: [
            videoRenderers(),
            offerAndAnswerButtons(),
            sdpCandidatesTF(),
            sdpCandidateButtons(),
          ],
        ));
  }
}
