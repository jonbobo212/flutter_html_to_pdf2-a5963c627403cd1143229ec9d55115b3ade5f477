import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Screen/HomePage/home.dart';

import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

enum OrderStatus {
  orders('assets/images/SVG/all_orders_icon.svg'),
  received('assets/images/SVG/received_icon.svg'),
  processed('assets/images/SVG/processed_icon.svg'),
  shipped('assets/images/SVG/shipped_icon.svg'),
  delivered('assets/images/SVG/delivered_icon.svg'),
  cancelled('assets/images/SVG/cancelled_icon.svg'),
  returned('assets/images/SVG/returned_icon.svg'),
  awaiting('assets/images/SVG/awaiting_icons.svg');

  final String assetIconSvgPath;

  const OrderStatus(this.assetIconSvgPath);

  String? get apiValue {
    switch (this) {
      case OrderStatus.received:
        return 'received';
      case OrderStatus.processed:
        return 'processed';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.returned:
        return 'returned';
      case OrderStatus.awaiting:
        return 'awaiting';
      default:
        return null;
    }
  }
}

typedef OrderResult = ({
  List<OrderModel> orders,
  List<Map<OrderStatus, String>> statusData,
  String total
});

class OrdersRepository {
  Future<OrderModel> fetchOrderById(String id) async {
    try {
      var response =
          await ApiBaseHelper().postAPICall(getOrdersApi, {'id': id});

      OrderModel order = OrderModel.fromJson(response['data'][0]);

      return order;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }

  Future<OrderResult> fetchOrders(
      {required String offset,
      String? searchString,
      DateTimeRange? dateRange,
      String? orderType,
      String? activeStatus}) async {
    try {
      var parameters = {
        'offset': offset,
        'limit': '10',
        if (searchString != null) 'search': searchString,
        if (activeStatus != null) 'active_status': activeStatus,
        if (dateRange != null)
          'start_date': DateFormat('yyyy/MM-dd').format(dateRange.start),
        if (dateRange != null)
          'end_date': DateFormat('yyyy/MM-dd').format(dateRange.end),
        if (orderType != null) 'order_type': orderType,
      };
      var response =
          await ApiBaseHelper().postAPICall(getOrdersApi, parameters);

      List<OrderModel> orders = (response['data'] as List).map(
        (e) {
          return OrderModel.fromJson(e);
        },
      ).toList();

      return (
        orders: orders,
        total: response['total'].toString(),
        statusData: [
          {
            OrderStatus.orders: response['total'].toString(),
          },
          {
            OrderStatus.received: response['received'].toString(),
          },
          {
            OrderStatus.processed: response['processed'].toString(),
          },
          {
            OrderStatus.shipped: response['shipped'].toString(),
          },
          {
            OrderStatus.delivered: response['delivered'].toString(),
          },
          {
            OrderStatus.cancelled: response['cancelled'].toString(),
          },
          {
            OrderStatus.returned: response['returned'].toString(),
          },
          {
            OrderStatus.awaiting: response['awaiting'].toString(),
          }
        ]
      );
    } catch (e, st) {
      log('Issue is $e and trace is $st');
      rethrow;
    }
  }

  Future<OrderModel> updateDigitalOrderItemStatus(
      {required String orderID,
      required String status,
      required String itemId}) async {
    var response = await apiBaseHelper.postAPICall(digitalOrderStatusUpdate, {
      "order_id": orderID,
      "status": status,
      "order_item_ids": itemId,
    });
    if (response['error']) {
      throw response['message'];
    }
    return OrderModel.fromJson((response['data']));
  }

  static Future<void> editOrderTracking({
    required String consignmentId,
    required String courierAgency,
    required String trackingId,
    required String url,
  }) async {
    try {
      final parameters = {
        'consignment_id': consignmentId,
        'courier_agency': courierAgency,
        'tracking_id': trackingId,
        'url': url,
      };
      return await ApiBaseHelper()
          .postAPICall(editOrderTrackingApi, parameters);
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }
}
