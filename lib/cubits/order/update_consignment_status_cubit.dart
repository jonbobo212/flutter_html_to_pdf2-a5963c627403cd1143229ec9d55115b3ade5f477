// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';

import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Repository/consignment_repository.dart';

class UpdateConsignmentStatusState {}

class UpdateConsignmentStatusInitial extends UpdateConsignmentStatusState {}

class UpdateConsignmentStatusInProgress extends UpdateConsignmentStatusState {}

class UpdateConsignmentStatusInSuccess extends UpdateConsignmentStatusState {
  final ConsignmentModel result;
  UpdateConsignmentStatusInSuccess({
    required this.result,
  });
}

class UpdateConsignmentStatusFail<T> extends UpdateConsignmentStatusState {
  final T error;
  UpdateConsignmentStatusFail(this.error);
}

class UpdateConsignmentStatusCubit extends Cubit<UpdateConsignmentStatusState> {
  UpdateConsignmentStatusCubit() : super(UpdateConsignmentStatusInitial());
  final ConsignmentRepository _consignmentRepository = ConsignmentRepository();
  void update({
    required String consignmentId,
    required String status,
     String? deliveryboyId,
     String? otp
  }) async {
    try {
      emit(UpdateConsignmentStatusInProgress());
      ConsignmentModel result = await _consignmentRepository.updateStatus(
          consignmentId: consignmentId,
          status: status,
          deliveryBoyId: deliveryboyId ?? "", 
          otp: otp ?? "" );
      emit(UpdateConsignmentStatusInSuccess(result: result));
    } catch (e) {
      emit(UpdateConsignmentStatusFail(e));
    }
  }
}
