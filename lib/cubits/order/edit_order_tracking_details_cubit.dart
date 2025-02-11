import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Repository/ordeListRepositry.dart';

abstract class EditOrderTrackingDetailsState {}

class EditOrderTrackingDetailsInitial extends EditOrderTrackingDetailsState {}

class EditOrderTrackingDetailsInProgress
    extends EditOrderTrackingDetailsState {}

class EditOrderTrackingDetailsSuccess extends EditOrderTrackingDetailsState {}

class EditOrderTrackingDetailsFail extends EditOrderTrackingDetailsState {
  final String error;
  EditOrderTrackingDetailsFail(this.error);
}

class EditOrderTrackingDetailsCubit
    extends Cubit<EditOrderTrackingDetailsState> {
  EditOrderTrackingDetailsCubit() : super(EditOrderTrackingDetailsInitial());

  void editOrderTrackingDetails({
    required String consignmentId,
    required String courierAgency,
    required String trackingId,
    required String url,
  }) async {
    try {
      emit(EditOrderTrackingDetailsInProgress());

      await OrdersRepository.editOrderTracking(
        consignmentId: consignmentId,
        courierAgency: courierAgency,
        trackingId: trackingId,
        url: url,
      );
      emit(EditOrderTrackingDetailsSuccess());
    } catch (e) {
      emit(EditOrderTrackingDetailsFail(e.toString()));
    }
  }
}
