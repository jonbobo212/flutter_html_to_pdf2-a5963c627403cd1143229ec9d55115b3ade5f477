// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/delivery_boy_model.dart';

import 'package:sellermultivendor/Repository/deliveryboy_repository.dart';

class FetchDeliveryboyState {}

class FetchDeliveryboyInitial extends FetchDeliveryboyState {}

class FetchDeliveryboyInProgress extends FetchDeliveryboyState {}

class FetchDeliveryboySuccess extends FetchDeliveryboyState {
  final String? search;
  final int offset;
  final bool isLoadingMore;
  final bool isLoadMoreHasError;
  final DeliveryBoyResult result;
  FetchDeliveryboySuccess({
    this.search,
    required this.offset,
    required this.result,
    required this.isLoadingMore,
    required this.isLoadMoreHasError,
  });

  FetchDeliveryboySuccess copyWith({
    String? search,
    int? offset,
    bool? isLoadingMore,
    bool? isLoadMoreHasError,
    DeliveryBoyResult? result,
  }) {
    return FetchDeliveryboySuccess(
      search: search ?? this.search,
      offset: offset ?? this.offset,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreHasError: isLoadMoreHasError ?? this.isLoadMoreHasError,
      result: result ?? this.result,
    );
  }
}

class FetchDeliveryboyFail<T> extends FetchDeliveryboyState {
  final T e;
  FetchDeliveryboyFail(this.e);
}

class FetchDeliveryboyCubit extends Cubit<FetchDeliveryboyState> {
  FetchDeliveryboyCubit() : super(FetchDeliveryboyInitial());
  DeliveryboyRepository deliveryboyRepository = DeliveryboyRepository();

  void fetch({String? search}) async {
    try {
      emit(FetchDeliveryboyInProgress());
      DeliveryBoyResult result = await deliveryboyRepository.getDeliveryBoys(
          search: search, offset: '0');
      emit(FetchDeliveryboySuccess(
          offset: 0,
          search: search,
          isLoadMoreHasError: false,
          result: result,
          isLoadingMore: false));
    } catch (e) {
      emit(FetchDeliveryboyFail(e));
    }
  }

  bool hasMore() {
    if (state is FetchDeliveryboySuccess) {
      return (state as FetchDeliveryboySuccess).result.deliveryBoys.length <
          (state as FetchDeliveryboySuccess).result.total.toInt();
    }
    return false;
  }

  Future fetchMore() async {
    if (!hasMore()) {
      return;
    }
    if (state is FetchDeliveryboySuccess) {
      FetchDeliveryboySuccess successState = state as FetchDeliveryboySuccess;
      if (successState.isLoadingMore) return;
      try {
        emit(successState.copyWith(isLoadingMore: true));
        DeliveryBoyResult result = await deliveryboyRepository.getDeliveryBoys(
            search: successState.search,
            offset: successState.result.deliveryBoys.length.toString());
        List<DeliveryBoy> customers = successState.result.deliveryBoys;
        customers.addAll(result.deliveryBoys);

        emit(FetchDeliveryboySuccess(
            result: result,
            isLoadingMore: false,
            isLoadMoreHasError: false,
            search: successState.search,
            offset: result.deliveryBoys.length));
      } catch (e) {
        emit(successState.copyWith(
            isLoadingMore: false, isLoadMoreHasError: true));
      }
    }
  }
}
