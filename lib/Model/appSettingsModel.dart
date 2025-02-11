class AppSettingsModel {
  bool isSMSGatewayOn;
  bool isCityWiseDeliveribility;
  String defaultCountryCode;
  AppSettingsModel({
    required this.isSMSGatewayOn,
    required this.isCityWiseDeliveribility,
    required this.defaultCountryCode,
  });

  factory AppSettingsModel.fromMap(Map<String, dynamic> data) {
    
    return AppSettingsModel(
        isSMSGatewayOn: data['authentication_settings'] != null &&
                data['authentication_settings'].isNotEmpty
            ? data['authentication_settings'][0]['authentication_method']
                    .toString()
                    .toLowerCase() ==
                'sms'
            : false,
        isCityWiseDeliveribility: data['shipping_method'] != null &&
                data['shipping_method'].isNotEmpty
            ? data['shipping_method'][0]['city_wise_deliverability'].toString() == "1"
            : false,
        defaultCountryCode: data['system_settings'] != null &&
                data['system_settings'].isNotEmpty
            ? data['system_settings'][0]['default_country_code']
            : 'IN');
  }
}
