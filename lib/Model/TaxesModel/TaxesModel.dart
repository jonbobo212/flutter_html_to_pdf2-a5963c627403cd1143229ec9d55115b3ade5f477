import 'package:sellermultivendor/Widget/parameterString.dart';

class TaxesModel {
  String? id, title, percentage, status, sellerId;

  TaxesModel({
    this.id,
    this.title,
    this.percentage,
    this.status,
    this.sellerId,
  });

  bool get editDeleteAllowed => sellerId?.trim() != '0';

  factory TaxesModel.fromJson(Map<String, dynamic> json) {
    return TaxesModel(
      id: json[Id],
      title: json[Title],
      percentage: json[Percentage],
      status: json[STATUS],
      sellerId: json['seller_id'],
    );
  }

  @override
  String toString() {
    return title!;
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#$id $title';
  }

  @override
  bool operator ==(other) => other is TaxesModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

