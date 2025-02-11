import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Repository/consignment_repository.dart';

abstract class DeleteConsignmentState {}

class DeleteConsignmentInitial extends DeleteConsignmentState {}

class DeleteConsignmentInProgress extends DeleteConsignmentState {
  String id;
  DeleteConsignmentInProgress({required this.id});
}

class DeleteConsignmentSuccess extends DeleteConsignmentState {
  OrderModel orderModel;
  String id;
  DeleteConsignmentSuccess({required this.id, required this.orderModel});
}

class DeleteConsignmentFail<T> extends DeleteConsignmentState {
  final T error;
  DeleteConsignmentFail(this.error);
}

class DeleteConsignmentCubit extends Cubit<DeleteConsignmentState> {
  DeleteConsignmentCubit() : super(DeleteConsignmentInitial());
  final ConsignmentRepository _consignmentRepository = ConsignmentRepository();

  void delete(String id) async {
    try {
      emit(DeleteConsignmentInProgress(id: id));
      OrderModel orderModel =
          await _consignmentRepository.cancelConsignment(id);
      emit(DeleteConsignmentSuccess(id: id, orderModel: orderModel));
    } catch (e) {
      emit(DeleteConsignmentFail(e));
    }
  }
}
