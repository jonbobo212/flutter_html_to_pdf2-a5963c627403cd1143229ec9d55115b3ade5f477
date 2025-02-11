import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Repository/shiprocket_repository.dart';

abstract class UpdateShiprocketOrderStatusState {}

class UpdateShiprocketOrderStatusInitial
    extends UpdateShiprocketOrderStatusState {}

class UpdateShiprocketOrderStatusInProgress
    extends UpdateShiprocketOrderStatusState {}

class UpdateShiprocketOrderStatusSuccess
    extends UpdateShiprocketOrderStatusState {
  final ConsignmentModel consignment;
  UpdateShiprocketOrderStatusSuccess(this.consignment);
}

class UpdateShiprocketOrderStatusFail extends UpdateShiprocketOrderStatusState {
  final String errorMessage;
  UpdateShiprocketOrderStatusFail(this.errorMessage);
}

class UpdateShiprocketOrderStatusCubit
    extends Cubit<UpdateShiprocketOrderStatusState> {
  UpdateShiprocketOrderStatusCubit()
      : super(UpdateShiprocketOrderStatusInitial());

  void updateShiprocketOrderStatus({required String trackingId}) async {
    try {
      emit(UpdateShiprocketOrderStatusInProgress());
      final newConsignment = await ShiprocketRepository()
          .updateShipRocketOrderStatus(trackingId: trackingId);
      emit(UpdateShiprocketOrderStatusSuccess(newConsignment));
    } catch (e) {
      emit(UpdateShiprocketOrderStatusFail(e.toString()));
    }
  }
}
