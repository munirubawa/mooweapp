import 'package:enum_to_string/enum_to_string.dart';
import 'package:mooweapp/enums.dart';

class CarInformation{
  String? carModel;
  String? carNumberPlate;
  String? carColor;
  String? carMaker;
  String? carBuildYear;
  String? licenceIssueAndExpirationDate;
RideType? rideType;
//<editor-fold desc="Data Methods">

  CarInformation({
    this.carModel,
    this.carNumberPlate,
    this.carColor,
    this.carMaker,
    this.carBuildYear,
    this.licenceIssueAndExpirationDate,
    this.rideType,
  });

  Map<String, dynamic> toMap() {
    return {
      'carModel': carModel,
      'carNumberPlate': carNumberPlate,
      'carColor': carColor,
      'carMaker': carMaker,
      'carBuildYear': carBuildYear,
      'licenceIssueAndExpirationDate': licenceIssueAndExpirationDate,
      'rideType': EnumToString.convertToString(rideType),

    };
  }

  factory CarInformation.fromMap(Map<String, dynamic> map) {
    return CarInformation(
      carModel: map['carModel'] as String,
      carNumberPlate: map['carNumberPlate'] as String,
      carColor: map['carColor'] as String,
      carMaker: map['carMaker'] as String,
      carBuildYear: map['carBuildYear'] as String,
      licenceIssueAndExpirationDate: map['licenceIssueAndExpirationDate'] as String,
      rideType: EnumToString.fromString(RideType.values, map['rideType']),
    );
  }

//</editor-fold>
}