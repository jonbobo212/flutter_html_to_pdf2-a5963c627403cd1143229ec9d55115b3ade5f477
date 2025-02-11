import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Repository/shiprocket_repository.dart';

abstract class CancelShiprocketOrderState {}

class CancelShiprocketOrderInitial extends CancelShiprocketOrderState {}

class CancelShiprocketOrderInProgress extends CancelShiprocketOrderState {}

class CancelShiprocketOrderSuccess extends CancelShiprocketOrderState {
  final ConsignmentModel consignment;
  CancelShiprocketOrderSuccess(this.consignment);
}

class CancelShiprocketOrderFail extends CancelShiprocketOrderState {
  final String errorMessage;
  CancelShiprocketOrderFail(this.errorMessage);
}

class CancelShiprocketOrderCubit extends Cubit<CancelShiprocketOrderState> {
  CancelShiprocketOrderCubit() : super(CancelShiprocketOrderInitial());

  void cancelShiprocketOrder({required String shiprocketOrderId}) async {
    try {
      emit(CancelShiprocketOrderInProgress());
      final newConsignment = await ShiprocketRepository()
          .cancelShipRocketOrder(shiprocketOrderId: shiprocketOrderId);
      emit(CancelShiprocketOrderSuccess(newConsignment));
    } catch (e) {
      emit(CancelShiprocketOrderFail(e.toString()));
    }
  }
}
