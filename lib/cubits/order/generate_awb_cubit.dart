import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Repository/generateAWBRepository.dart';

abstract class GenerateAWBState {}

class GenerateAWBInitial extends GenerateAWBState {}

class GenerateAWBInProgress extends GenerateAWBState {}

class GenerateAWBSuccess extends GenerateAWBState {
  final ConsignmentModel result;
  GenerateAWBSuccess({
    required this.result,
  });
}

class GenerateAWBFailure extends GenerateAWBState {
  final String errorMessage;

  GenerateAWBFailure(this.errorMessage);
}

class GenerateAWBCubit extends Cubit<GenerateAWBState> {
  final GenerateAWBRepository generateAWBRepository;

  GenerateAWBCubit(this.generateAWBRepository) : super(GenerateAWBInitial());

  void generateAWB({
    required String shipmentId,
  }) async {
    try {
      emit(GenerateAWBInProgress());
      ConsignmentModel result =
          await generateAWBRepository.generateAWB(shipmentId: shipmentId);

      emit(GenerateAWBSuccess(result: result));
    } catch (e) {
      emit(GenerateAWBFailure(e.toString()));
    }
  }
}
