import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Repository/consignment_repository.dart';

class FetchConsignmentLabelState {}

class FetchConsignmentLabelInitial extends FetchConsignmentLabelState {}

class FetchConsignmentLabelProgress extends FetchConsignmentLabelState {}

class FetchConsignmentLabelSuccess extends FetchConsignmentLabelState {
  final String consignmentLabel;
  FetchConsignmentLabelSuccess(this.consignmentLabel);
}

class FetchConsignmentLabelFailure extends FetchConsignmentLabelState {
  final String error;
  FetchConsignmentLabelFailure(this.error);
}

class FetchConsignmentLabelCubit extends Cubit<FetchConsignmentLabelState> {
  FetchConsignmentLabelCubit() : super(FetchConsignmentLabelInitial());

  Future<void> fetchConsignmentLabel(String shipmentID) async {
    emit(FetchConsignmentLabelInitial());
    try {
      emit(FetchConsignmentLabelProgress());

      dynamic response =
          await ConsignmentRepository().fetchConsignmentLabel(shipmentID);

      emit(FetchConsignmentLabelSuccess(response));
    } catch (e) {
      emit(FetchConsignmentLabelFailure(e.toString()));
    }
  }
}
