// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';

import 'package:sellermultivendor/Repository/consignment_repository.dart';

@immutable
class FetchConsignmentsState {}

class FetchConsignmentsInitial extends FetchConsignmentsState {}

class FetchConsignmentsInProgress extends FetchConsignmentsState {}

class FetchConsignmentsSuccess extends FetchConsignmentsState {
  final int offset;
  final ConsignmentResult consignmentResult;
  final bool isLoadingMore;
  final bool isLoadMoreHasError;
  FetchConsignmentsSuccess({
    required this.offset,
    required this.consignmentResult,
    required this.isLoadingMore,
    required this.isLoadMoreHasError,
  });

  FetchConsignmentsSuccess copyWith({
    int? offset,
    ConsignmentResult? consignmentResult,
    bool? isLoadingMore,
    bool? isLoadMoreHasError,
  }) {
    return FetchConsignmentsSuccess(
      offset: offset ?? this.offset,
      consignmentResult: consignmentResult ?? this.consignmentResult,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreHasError: isLoadMoreHasError ?? this.isLoadMoreHasError,
    );
  }
}

class FetchConsignmentsFail<T> extends FetchConsignmentsState {
  final T e;
  FetchConsignmentsFail(this.e);
}

class FetchConsignmentsCubit extends Cubit<FetchConsignmentsState> {
  final ConsignmentRepository _consignmentRepository;
  FetchConsignmentsCubit(this._consignmentRepository)
      : super(FetchConsignmentsInitial());
  void remove(String id) {
    if (state is FetchConsignmentsSuccess) {
      final stateAs = state as FetchConsignmentsSuccess;
      ConsignmentResult consignmentResult = stateAs.consignmentResult;
      List<ConsignmentModel> consignments = consignmentResult.consignments;
      consignments.removeWhere((element) => element.id == id);
      emit(stateAs.copyWith(consignmentResult: consignmentResult));
    }
  }

  void fetch({required String orderId}) async {
    try {
      emit(FetchConsignmentsInProgress());
      ConsignmentResult result = await _consignmentRepository.getConsignments(
          orderId: orderId, offset: '0');
      emit(FetchConsignmentsSuccess(
          consignmentResult: result,
          isLoadMoreHasError: false,
          isLoadingMore: false,
          offset: 0));
      // print(
      //     "--> ${result.consignments.first.consignmentItems.first.variantName}");
    } catch (e) {
      emit(FetchConsignmentsFail(e));
    }
  }

  bool hasMore() {
    if (state is FetchConsignmentsSuccess) {
      return (state as FetchConsignmentsSuccess)
              .consignmentResult
              .consignments
              .length <
          (state as FetchConsignmentsSuccess).consignmentResult.total.toInt();
    }
    return false;
  }

  Future fetchMore() async {
    if (!hasMore()) {
      return;
    }
    if (state is FetchConsignmentsSuccess) {
      FetchConsignmentsSuccess successState = state as FetchConsignmentsSuccess;
      if (successState.isLoadingMore) return;
      try {
        emit(successState.copyWith(isLoadingMore: true));
        ConsignmentResult result = await _consignmentRepository.getConsignments(
          orderId: successState.consignmentResult.consignments.last.orderId,
          offset: successState.consignmentResult.consignments.length.toString(),
        );
        List<ConsignmentModel> customers =
            successState.consignmentResult.consignments;
        customers.addAll(result.consignments);

        emit(FetchConsignmentsSuccess(
          consignmentResult: result,
          isLoadingMore: false,
          isLoadMoreHasError: false,
          offset: result.consignments.length,
        ));
      } catch (e) {
        emit(successState.copyWith(
            isLoadingMore: false, isLoadMoreHasError: true));
      }
    }
  }

  void updateConsignment(ConsignmentModel consignment) {
    if (state is FetchConsignmentsSuccess) {
      final stateAs = state as FetchConsignmentsSuccess;
      ConsignmentResult consignmentResult = stateAs.consignmentResult;
      List<ConsignmentModel> consignments = consignmentResult.consignments;
      for (int i = 0; i < consignments.length; i++) {
        if (consignments[i].id == consignment.id) {
          consignments[i].changeValues(consignment);
          break;
        }
      }
      emit(stateAs.copyWith(consignmentResult: consignmentResult));
    }
  }
}
