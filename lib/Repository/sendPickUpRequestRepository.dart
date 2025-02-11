import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Widget/api.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';

class SendPickUpRepository {
  Future<ConsignmentModel> sendPickupRequest(
      {required String shipmentId}) async {
    print("issend------> ");
    var parameter = {
      SHIPMENT_ID: shipmentId,
    };
    try {
      var response =
          await ApiBaseHelper().postAPICall(sendPickUpRequestApi, parameter);

      // Validate response
      if (response['error'] == true) {
        throw ApiException(response['message']);
      }

      return ConsignmentModel.fromMap((response['data']));
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }
}
