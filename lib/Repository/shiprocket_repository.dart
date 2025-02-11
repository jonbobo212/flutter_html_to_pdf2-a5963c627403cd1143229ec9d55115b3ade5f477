import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Screen/HomePage/home.dart';
import 'package:sellermultivendor/Widget/api.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';

class ShiprocketRepository {
  Future<ConsignmentModel> createShiprocketOrder({
    required String consignmentId,
    required String selectPickUpLocation,
    required String weight,
    required String height,
    required String breadth,
    required String length,
  }) async {
    try {
      var parameter = {
        'consignment_id': consignmentId,
        PICKUP_LOCATION: selectPickUpLocation,
        PARCEL_WEIGHT: weight.toString(),
        PARCEL_HEIGHT: height.toString(),
        PARCEL_BREADTH: breadth.toString(),
        PARCEL_LENGTH: length.toString()
      };

      var response =
          await apiBaseHelper.postAPICall(createShipRocketOrderApi, parameter);
      if (response['error'] == true) {
        throw response['message'];
      } else {
        return ConsignmentModel.fromMap(response['data']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ConsignmentModel> cancelShipRocketOrder(
      {required String shiprocketOrderId}) async {
    try {
      var parameter = {
        SHIPROCKET_ORDER_ID: shiprocketOrderId,
      };

      var response =
          await apiBaseHelper.postAPICall(cancelShipRocketOrderApi, parameter);

      if (response['error'] == true) {
        throw response['message'];
      } else {
        return ConsignmentModel.fromMap(response['data']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ConsignmentModel> updateShipRocketOrderStatus(
      {required String trackingId}) async {
    try {
      var parameter = {
        'tracking_id': trackingId,
      };

      var response = await apiBaseHelper.postAPICall(
          updateShipRocketOrderStatusApi, parameter);
      if (response['error'] == true) {
        throw response['message'];
      } else {
        return ConsignmentModel.fromMap(response['data']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
