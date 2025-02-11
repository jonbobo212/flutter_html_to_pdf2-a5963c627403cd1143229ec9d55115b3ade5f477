import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Repository/sendPickUpRequestRepository.dart';

abstract class SendPickUpRequestState {}

class SendPickUpRequestInitial extends SendPickUpRequestState {}

class SendPickUpRequestInProgress extends SendPickUpRequestState {}

class SendPickUpRequestSuccess extends SendPickUpRequestState {
  final ConsignmentModel result;
  SendPickUpRequestSuccess({
    required this.result,
  });
}

class SendPickUpRequestFailure extends SendPickUpRequestState {
  final String errorMessage;

  SendPickUpRequestFailure(this.errorMessage);
}

class SendPickUpRequestCubit extends Cubit<SendPickUpRequestState> {
  final SendPickUpRepository sendPickUpRepository;

  SendPickUpRequestCubit(this.sendPickUpRepository)
      : super(SendPickUpRequestInitial());

  void sendRequest({
    required String shipmentId,
  }) async {
    try {
      emit(SendPickUpRequestInProgress());
      ConsignmentModel result =
          await sendPickUpRepository.sendPickupRequest(shipmentId: shipmentId);

      emit(SendPickUpRequestSuccess(result: result));
    } catch (e) {
      emit(SendPickUpRequestFailure(e.toString()));
    }
  }
}
