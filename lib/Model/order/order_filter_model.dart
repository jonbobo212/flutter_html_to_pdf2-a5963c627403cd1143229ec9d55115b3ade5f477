import 'package:flutter/material.dart';

enum OrderType {
  all,
  simple,
  digital;

  String? get apiValue {
    switch (this) {
      case OrderType.simple:
        return 'simple';
      case OrderType.digital:
        return 'digital';
      default:
        return null;
    }
  }

//for showing in UI, returns key
  @override
  String toString() {
    switch (this) {
      case OrderType.simple:
        return 'SIMPLE';
      case OrderType.digital:
        return 'DIGITAL';
      default:
        return 'ALL';
    }
  }
}

class OrderListFilterModel {
  DateTimeRange? dateRange;
  OrderType orderType;

  OrderListFilterModel({this.dateRange, this.orderType = OrderType.all});

  bool hasAnyFilters() {
    return dateRange != null || orderType != OrderType.all;
  }

  void clearFilters() {
    dateRange = null;
    orderType = OrderType.all;
  }

  void applyFilters({required OrderListFilterModel filterModel}) {
    dateRange = filterModel.dateRange;
    orderType = filterModel.orderType;
  }
}
