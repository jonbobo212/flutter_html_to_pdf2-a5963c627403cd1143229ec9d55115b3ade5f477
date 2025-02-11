import 'package:bloc/bloc.dart';
import 'package:sellermultivendor/Repository/email_repository.dart';

class SendMailState {}

class SendMailInitial extends SendMailState {}

class SendMailInProgress extends SendMailState {}

class SendMailSuccess extends SendMailState {}

class SendMailFail<T> extends SendMailState {
  final T error;
  SendMailFail(this.error);
}

class SendMailCubit extends Cubit<SendMailState> {
  SendMailCubit() : super(SendMailInitial());
  final EmailRepository _emailRepository = EmailRepository();
  send({
    required String orderID,
    required String orderItemId,
    required String email,
    required String subject,
    required String message,
    required String attachment,
    required String username,
  }) async {
    try {
      emit(SendMailInProgress());
      await _emailRepository.sendMail(
        orderID: orderID,
        orderItemId: orderItemId,
        emailId: email,
        subject: subject,
        message: message,
        attachment: attachment,
        username: username,
      );
      emit(SendMailSuccess());
    } catch (e) {
      emit(SendMailFail(e));
    }
  }
}
