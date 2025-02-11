import 'package:sellermultivendor/Screen/HomePage/home.dart';
import 'package:sellermultivendor/Widget/api.dart';

class EmailRepository {
  Future sendMail({
    required String orderID,
    required String orderItemId,
    required String emailId,
    required String subject,
    required String message,
    required String attachment,
    required String username,
  }) async {
    Map<String, String> parameter = {
      'order_id': orderID,
      'order_item_id': orderItemId,
      'customer_email': emailId,
      'subject': subject,
      'message': message,
      'attachment': attachment,
      'username': username,
    };
    var response =
        await apiBaseHelper.postAPICall(sendDigitalProductMailApi, parameter);
    if (response["error"]) {
      throw Exception(response["message"]);
    }
  }
}
