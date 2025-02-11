import 'package:sellermultivendor/Widget/parameterString.dart';

class ZipCodeModel {
  String? id, zipcode;

  ZipCodeModel({
    this.id,
    this.zipcode,
  });

  factory ZipCodeModel.fromJson(Map<String, dynamic> json) {
    return ZipCodeModel(
      id: json[Id],
      zipcode: json[Zipcode],
    );
  }
}
