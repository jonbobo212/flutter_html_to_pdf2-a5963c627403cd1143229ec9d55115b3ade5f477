import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Repository/shiprocket_repository.dart';

abstract class CreateShiprocketOrderState {}

class CreateShiprocketOrderInitial extends CreateShiprocketOrderState {}

class CreateShiprocketOrderInProgress extends CreateShiprocketOrderState {}

class CreateShiprocketOrderSuccess extends CreateShiprocketOrderState {
  final ConsignmentModel consignment;
  CreateShiprocketOrderSuccess(this.consignment);
}

class CreateShiprocketOrderFail extends CreateShiprocketOrderState {
  final String errorMessage;
  CreateShiprocketOrderFail(this.errorMessage);
}

class CreateShiprocketOrderCubit extends Cubit<CreateShiprocketOrderState> {
  CreateShiprocketOrderCubit() : super(CreateShiprocketOrderInitial());

  void createShiprocketOrder(
      {required String consignmentId,
      required String selectPickUpLocation,
      required String weight,
      required String height,
      required String breadth,
      required String length}) async {
    try {
      emit(CreateShiprocketOrderInProgress());
      final newConsignment = await ShiprocketRepository().createShiprocketOrder(
          consignmentId: consignmentId,
          selectPickUpLocation: selectPickUpLocation,
          weight: weight,
          height: height,
          breadth: breadth,
          length: length);
      emit(CreateShiprocketOrderSuccess(newConsignment));
    } catch (e) {
      emit(CreateShiprocketOrderFail(e.toString()));
    }
  }
}
