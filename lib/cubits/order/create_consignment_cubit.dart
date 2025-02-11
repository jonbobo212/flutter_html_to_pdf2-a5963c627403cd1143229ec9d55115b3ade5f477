// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Repository/consignment_repository.dart';

class CreateConsignmentState {}

class CreateConsignmentInitial extends CreateConsignmentState {}

class CreateConsignmentInProgress extends CreateConsignmentState {}

class CreateConsignmentSuccess extends CreateConsignmentState {
  final List<String> orderItemItd;
  final String orderId;
  final String consignmentTitle;
  final OrderModel orderModel;
  CreateConsignmentSuccess({
    required this.orderItemItd,
    required this.orderId,
    required this.consignmentTitle,
    required this.orderModel,
  });
}

class CreateConsignmentFail<T> extends CreateConsignmentState {
  final T error;
  CreateConsignmentFail(this.error);
}

class CreateConsignmentCubit extends Cubit<CreateConsignmentState> {
  final ConsignmentRepository _consignmentRepository;
  CreateConsignmentCubit(this._consignmentRepository)
      : super(CreateConsignmentInitial());

  void create({
    required List<String> orderItemIds,
    required String orderId,
    required String consignmentTitle,
  }) async {
    try {
      emit(CreateConsignmentInProgress());
      OrderModel orderModel =
          await _consignmentRepository.createConsignment(
              orderId: orderId,
              consignmentTitle: consignmentTitle,
              orderItemIds: orderItemIds);
      emit(CreateConsignmentSuccess(
          orderItemItd: orderItemIds,
          orderId: orderId,
          orderModel: orderModel,
          consignmentTitle: consignmentTitle));
    } catch (e) {
      emit(CreateConsignmentFail(e));
    }
  }
}
