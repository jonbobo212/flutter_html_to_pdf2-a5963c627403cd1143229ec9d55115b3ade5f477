import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class ZipcodeRepository {
  // for add faqs.
  static Future<Map<String, dynamic>> setZipCode(
      {required int offset, required int limit, String? search}) async {
    try {
      var parameter = {
        "offset": offset.toString(),
        "limit": limit.toString(),
        if (search != null && search.trim().isNotEmpty) "search": search
      };
      var zipCodeDetail =
          await ApiBaseHelper().postAPICall(getZipcodesApi, parameter);

      return zipCodeDetail;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> getZipcodes({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
      await ApiBaseHelper().postAPICall(getZipcodesApi, parameter);

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }
}
