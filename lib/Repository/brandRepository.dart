import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class BrandRepository {
  // for add faqs.
  static Future<Map<String, dynamic>> setBrand({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var detail =
          await ApiBaseHelper().postAPICall(getBrandsDataApi, parameter);

      return detail;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }
}
