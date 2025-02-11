import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Screen/HomePage/home.dart';
import 'package:sellermultivendor/Widget/api.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';

typedef ConsignmentResult = ({
  List<ConsignmentModel> consignments,
  String total
});

class ConsignmentRepository {
  Future<ConsignmentResult> getConsignments(
      {required String orderId, required String offset}) async {
    Map<String, String> parameters = {
      'order_id': orderId,
      'in_detail': '1',
    };
    var response =
        await apiBaseHelper.postAPICall(getConsignmentApi, parameters);

    List<ConsignmentModel> consignments = (response['data'] as List)
        .map((e) => ConsignmentModel.fromMap(e))
        .toList();

    return (consignments: consignments, total: response['total'].toString());
  }

/*
 consignment_id:123
        status : received / processed / shipped / delivered / cancelled
        deliver_by:74 */
  Future<ConsignmentModel> updateStatus(
      {required String consignmentId,
      required String status,
      required String deliveryBoyId,
      required String otp}) async {
    Map<String, String> parameter = {
      'consignment_id': consignmentId,
      'status': status,
      'deliver_by': deliveryBoyId,
      'otp': otp
    };
    var response =
        await apiBaseHelper.postAPICall(updateConsignmentStatusApi, parameter);
    if (response['error'] == true) {
      throw response['message'];
    }
    return ConsignmentModel.fromMap((response['data']));
  }

  Future<OrderModel> createConsignment(
      {required String orderId,
      required List<String> orderItemIds,
      required String consignmentTitle}) async {
    try {
      Map<String, String> parameters = {
        'order_id': orderId,
        'order_item_ids': orderItemIds.join(','),
        'consignment_title': consignmentTitle,
      };

      var response =
          await apiBaseHelper.postAPICall(createConsignmentApi, parameters);
      if (response['error'] == true) {
        throw response['message'];
      }
      return OrderModel.fromJson((response['data']));
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderModel> cancelConsignment(String consignmentID) async {
    var response = await apiBaseHelper
        .postAPICall(deleteOrderConsignment, {'id': consignmentID});
    if (response['error'] == true) {
      throw response['message'];
    }
    return OrderModel.fromJson((response['data']));
  }

  Future<String> fetchConsignmentInvoice(String consignmentID) async {
    var response = await apiBaseHelper.postAPICall(
        fetchConsignmentInvoiceApi, {'consignment_id': consignmentID});

    return response;
  }

  Future<dynamic> fetchConsignmentLabel(String shipmentID) async {
    var parameter = {
      SHIPMENT_ID: shipmentID,
    };
    var response = await apiBaseHelper.postAPICall(downloadLabelApi, parameter);
    return response["data"];
  }
}
