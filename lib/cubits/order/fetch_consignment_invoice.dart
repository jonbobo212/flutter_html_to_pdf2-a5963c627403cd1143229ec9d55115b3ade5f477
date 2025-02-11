import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Repository/consignment_repository.dart';

class FetchConsignmentInvoiceState {}

class FetchConsignmentInvoiceInitial extends FetchConsignmentInvoiceState {}

class FetchConsignmentInvoiceProgress extends FetchConsignmentInvoiceState {}

class FetchConsignmentInvoiceSuccess extends FetchConsignmentInvoiceState {
  final String consignmentInvoice;
  FetchConsignmentInvoiceSuccess(this.consignmentInvoice);
}

class FetchConsignmentInvoiceFailure extends FetchConsignmentInvoiceState {
  final String error;
  FetchConsignmentInvoiceFailure(this.error);
}

class FetchConsignmentInvoiceCubit extends Cubit<FetchConsignmentInvoiceState> {
  FetchConsignmentInvoiceCubit() : super(FetchConsignmentInvoiceInitial());
  Future<void> fetchConsignmentInvoice(String consignmentID) async {
    emit(FetchConsignmentInvoiceInitial());
    try {
      emit(FetchConsignmentInvoiceProgress());
      String consignmentInvoice =
          await ConsignmentRepository().fetchConsignmentInvoice(consignmentID);
      emit(FetchConsignmentInvoiceSuccess(consignmentInvoice));
    } catch (e) {
      emit(FetchConsignmentInvoiceFailure(e.toString()));
    }
  }
}
