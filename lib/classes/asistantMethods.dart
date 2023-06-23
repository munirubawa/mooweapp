// import 'dart:convert';
// import 'dart:math';
//
// import 'package:geolocator/geolocator.dart';
// import 'package:google_geocoding/google_geocoding.dart';
// // import 'package:get/get.dart';
// import 'package:google_maps_webservice/directions.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:mooweapp/classes/address.dart';
// import 'package:mooweapp/classes/directionDetailes.dart';
// import 'package:mooweapp/classes/requestAssistance.dart';
// import 'package:mooweapp/configMaps.dart';

import 'package:mooweapp/export_files.dart';
// import 'package:geocoding/geocoding.dart' as geo;
// import 'package:location/location.dart' as locationData;

class AssistantMethods {
  // static Future<String> searchCoordinateAddress(Position position) async {
  //   String placeAddress = "";
  //   String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},"
  //       "${position.longitude}&key=${apiController.apiKeyModel.value.googleMapApiKey}";
  //
  //   var response = await RequestAssistance.getRequest(url);
  //
  //   // RiderAppData riderAppData = Get.put(RiderAppData()) ;
  //   // RiderHomeScreenController riderController = Get.find();
  //
  //   if (response != "failed") {
  //     GeocodingResponse geocodingResponse = GeocodingResponse.fromJson(response);
  //     placeAddress = response["results"][0]["formatted_address"];
  //
  //     Address userPickupAddress = Address();
  //     userPickupAddress.placeFormattedAddress = geocodingResponse.results![0].formattedAddress!;
  //     userPickupAddress.location =
  //         geo.Location(longitude: position.longitude, latitude: position.latitude, timestamp: DateTime.now());
  //     userPickupAddress.placeName = placeAddress;
  //     userPickupAddress.placeId = response["results"][0]["place_id"];
  //     userPickupAddress.shortName = geocodingResponse.results![0].addressComponents![5].shortName!;
  //     // riderController.updatePickupAddress(userPickupAddress);
  //   }
  //   return placeAddress;
  // }

  // static Future<String?> searchLocationDataAddress(locationData.LocationData locationData) async {
  //   String placeAddress = "";
  //   String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.latitude},"
  //       "${locationData.longitude}&key=${apiController.apiKeyModel.value.googleMapApiKey}";
  //
  //   var response = await RequestAssistance.getRequest(url);
  //
  //   // RiderAppData riderAppData = Get.find();
  //
  //   var addresses =
  //       await geo.GeocodingPlatform.instance.placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
  //   var first = addresses.first;
  //   // print(first.toJson());
  //   // print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
  //
  //   if (response != "failed") {
  //     GeocodingResponse geocodingResponse = GeocodingResponse.fromJson(response);
  //     placeAddress = response["results"][0]["formatted_address"];
  //     Address userPickupAddress = Address();
  //     userPickupAddress.placeFormattedAddress = geocodingResponse.results![0].formattedAddress!;
  //     userPickupAddress.location =
  //         geo.Location(longitude: locationData.longitude!, latitude: locationData.latitude!, timestamp: DateTime.now());
  //     userPickupAddress.placeName = placeAddress;
  //     userPickupAddress.placeId = response["results"][0]["place_id"];
  //     userPickupAddress.shortName = geocodingResponse.results![0].addressComponents![5].shortName!;
  //     // riderAppData.updatePickupAddress(userPickupAddress);
  //
  //   }
  //   return first.locality;
  // }

  // static Future<DirectionDetails?> obtainDirectionDetails(
  //     {required LatLng pickUpLatLang, required LatLng destinationLatLang}) async {
  //   String direction = "https://maps.googleapis"
  //       ".com/maps/api/directions/json?origin=${pickUpLatLang.latitude},"
  //       "${pickUpLatLang.longitude}&destination=${destinationLatLang.latitude},"
  //       "${destinationLatLang.longitude}&key=$GOOGLE_MAPS_API_KEY";
  //
  //   var res = await RequestAssistance.getRequest(direction);
  //   if (res == "failed") {
  //     return null;
  //   }
  //
  //   DirectionDetails details = DirectionDetails();
  //   DirectionsResponse directionsResponse = DirectionsResponse.fromJson(res);
  //
  //   // print("directionsResponse");
  //   // print(directionsResponse.status);
  //   details.encodedPoints = directionsResponse.routes[0].overviewPolyline.points;
  //   details.distanceText = directionsResponse.routes[0].legs[0].distance.text;
  //   details.distanceValue = directionsResponse.routes[0].legs[0].distance.value.toInt();
  //
  //   details.durationText = directionsResponse.routes[0].legs[0].duration.text;
  //   details.durationValue = directionsResponse.routes[0].legs[0].duration.value.toInt();
  //   return details;
  // }

  // static int calculateFares(DirectionDetails details) {
  //   double timeTraveledFare = (details.durationValue! / 60) * 0.70;
  //   double distanceTraveledFare = (details.durationValue! / 1000) * 0.70;
  //   double totalFareAmount = timeTraveledFare + distanceTraveledFare;
  //
  //   // Local Currency
  //   // $1 = GHS 5.6
  //   // double totalLocalAmount = totalFareAmount * 5.6
  //
  //   return totalFareAmount.truncate();
  // }

  static double createRandomNumber(int num) {
    var random = Random();
    int randNumber = random.nextInt(num);
    return randNumber.toDouble();
  }

  static sendANotification({
    required String token,
    required notificationDocPath,
    required title,
    required body,
    required notificationType,
    Map<String, dynamic>? extraData,
  }) async {
    var headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${apiController.apiKeyModel.value.serverToken}'};
    var request = Request('POST',
        Uri.parse('https://fcm.googleapis.com/fcm/send?Content-Type=application/json&Authorization=key=${apiController.apiKeyModel.value.serverToken}'));
    // request.body = '''{
    // "notification": {"body": "$body", "title": "$title"},
    //  "priority":"high",
    //  "data": {
    //  "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //  "id": "${DateTime.now().microsecondsSinceEpoch}",
    //  "status": "done",
    //  "notificationDocPath": "$notificationDocPath",
    //  "type": "$notificationType"
    //  },
    //  "to": "$token",
    //  }''';
    request.body = json.encode({
      'to': token,
      'token': token,
      'contentAvailable': true,
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': DateTime.now().microsecondsSinceEpoch.toString(),
        'sound': 'default',
        'status': 'done',
        'notificationDocPath': notificationDocPath,
        'type': notificationType,
        'extraData': json.encode(extraData),
      },
      'notification': {
        'title': title,
        'body': body,
      },
      'android': {
        'notification': {
          'sound': 'default'
        },
      },
      'apns': {
        'headers': {
          'apns-priority': 5,
        },
        'payload': {
          'aps': {
            'content-available': 1,
          },
        },
      },
    });

    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    // print("sendANotification");
    // print(token);
    if (response.statusCode == 200) {
      print("sendANotification success");

      response.stream.bytesToString().then((value){
        print("response.stream.bytesToString $value");
      });
    } else {
      print("sendANotification failed");

      print(response.reasonPhrase);
      response.stream.bytesToString().then((value){
        print("response.stream.bytesToString $value");
      });
    }
  }

  static String formatTripDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }
}
