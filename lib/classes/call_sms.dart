import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class CallsAndMessagesService {
  void call(int phone) async {
    var url =  "tel:${phone.toString()}";

    if(await canLaunch(url)){
      await launch(url);
    } else {
      throw "could not luanch url";
    }
  }
  void sendSms(int phone) async {
    var url = Platform.isAndroid? "sms:${phone.toString()}?body=hello%20there": "sms:${phone.toString()
    }&body=hello%20there";
    if(await canLaunch(url)){
      await launch(url);
    } else {
      throw "could not luanch url";
    }
  }
  void sendEmail(String email) => canLaunch("mailto:$email");
}
