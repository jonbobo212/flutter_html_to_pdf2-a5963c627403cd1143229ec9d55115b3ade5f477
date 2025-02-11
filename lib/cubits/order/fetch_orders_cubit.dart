// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Repository/ordeListRepositry.dart';

class FetchOrdersState {}

class FetchOrdersInitial extends FetchOrdersState {}

class FetchOrdersInProgress extends FetchOrdersState {}

class FetchOrdersSuccess extends FetchOrdersState {
  final OrderResult result;
  final bool loadingMore;
  final bool loadingMoreError;
  final OrderStatus currentOrderStatus;

  //old filters storage for refreshing from other screens
  final String? searchString;
  final DateTimeRange? dateRange;
  final String? activeStatus;
  final String? orderType;

  FetchOrdersSuccess({
    required this.result,
    required this.loadingMore,
    required this.loadingMoreError,
    required this.currentOrderStatus,
    this.searchString,
    this.dateRange,
    this.activeStatus,
    this.orderType,
  });

  FetchOrdersSuccess copyWith({
    OrderResult? result,
    bool? loadingMore,
    bool? loadingMoreError,
    OrderStatus? currentOrderStatus,
    String? searchString,
    DateTimeRange? dateRange,
    String? activeStatus,
    String? orderType,
  }) {
    return FetchOrdersSuccess(
      result: result ?? this.result,
      loadingMore: loadingMore ?? this.loadingMore,
      loadingMoreError: loadingMoreError ?? this.loadingMoreError,
      currentOrderStatus: currentOrderStatus ?? this.currentOrderStatus,
      searchString: searchString ?? this.searchString,
      dateRange: dateRange ?? this.dateRange,
      activeStatus: activeStatus ?? this.activeStatus,
      orderType: orderType ?? this.orderType,
    );
  }
}

class FetchOrdersFail<T> extends FetchOrdersState {
  T error;
  FetchOrdersFail(this.error);
}

class FetchOrdersCubit extends Cubit<FetchOrdersState> {
  final OrdersRepository _ordersRepository;
  FetchOrdersCubit(this._ordersRepository) : super(FetchOrdersInitial());

  void fetch({
    String? searchString,
    DateTimeRange? dateRange,
    String? activeStatus,
    bool isScrollTriggered = false,
    String? orderType,
  }) async {
    try {
      if (state is FetchOrdersInProgress) {
        return;
      }
      if (state is FetchOrdersSuccess && isScrollTriggered) {
        _fetchMore(
            successSate: state as FetchOrdersSuccess,
            searchString: searchString,
            dateRange: dateRange,
            activeStatus: activeStatus,
            orderType: orderType);
      } else {
        emit(FetchOrdersInProgress());
        OrderResult result = await _ordersRepository.fetchOrders(
            offset: '0',
            searchString: searchString,
            dateRange: dateRange,
            activeStatus: activeStatus,
            orderType: orderType);

        emit(FetchOrdersSuccess(
          result: result,
          loadingMore: false,
          loadingMoreError: false,
          currentOrderStatus: OrderStatus.orders,
          searchString: searchString,
          dateRange: dateRange,
          activeStatus: activeStatus,
          orderType: orderType,
        ));
      }
    } catch (e) {
      emit(FetchOrdersFail(e));
    }
  }

  Future<void> _fetchMore(
      {required FetchOrdersSuccess successSate,
      String? activeStatus,
      String? searchString,
      String? orderType,
      DateTimeRange? dateRange}) async {
    try {
      //don't fetch more if we have reached the end of the list
      if (int.parse(successSate.result.total) <=
          successSate.result.orders.length) {
        return;
      }
      if (successSate.loadingMore) {
        return;
      }
      emit(successSate.copyWith(loadingMore: true));
      OrderResult result = await _ordersRepository.fetchOrders(
          offset: successSate.result.orders.length.toString(),
          searchString: searchString,
          dateRange: dateRange,
          orderType: orderType,
          activeStatus: activeStatus);
      emit(FetchOrdersSuccess(
        result: result..orders.insertAll(0, successSate.result.orders),
        loadingMore: false,
        loadingMoreError: false,
        currentOrderStatus: successSate.currentOrderStatus,
        searchString: searchString,
        dateRange: dateRange,
        activeStatus: activeStatus,
        orderType: orderType,
      ));
    } catch (e) {
      emit(FetchOrdersSuccess(
        result: successSate.result,
        loadingMore: false,
        loadingMoreError: true,
        currentOrderStatus: successSate.currentOrderStatus,
        searchString: searchString,
        dateRange: dateRange,
        activeStatus: activeStatus,
        orderType: orderType,
      ));
    }
  }

  //refresh from other screens with filters
  void refreshOrderList() {
    String? searchString;
    DateTimeRange? dateRange;
    String? activeStatus;
    String? orderType;
    if (state is FetchOrdersSuccess) {
      final stateAs = state as FetchOrdersSuccess;
      searchString = stateAs.searchString;
      dateRange = stateAs.dateRange;
      activeStatus = stateAs.activeStatus;
      orderType = stateAs.orderType;
    }
    fetch(
        activeStatus: activeStatus,
        searchString: searchString,
        dateRange: dateRange,
        orderType: orderType);
  }

  void updateOrder(OrderModel order) {
    if (state is FetchOrdersSuccess) {
      final stateAs = state as FetchOrdersSuccess;
      List<OrderModel> orders = stateAs.result.orders;
      for (int i = 0; i < orders.length; i++) {
        if (orders[i].id == order.id) {
          orders[i].changeValues(order);
          break;
        }
      }
      emit(stateAs.copyWith(result: stateAs.result));
    }
  }
}
