import 'package:sellermultivendor/Screen/HomePage/home.dart';

import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class CategoryRepository {
  static Future<Map<String, dynamic>> setCategory({
    required Map<dynamic, dynamic> parameter,
  }) async {
    try {
      var taxDetail =
          await ApiBaseHelper().postAPICall(getCategoriesApi, parameter);

      return taxDetail;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> setCategoryList(
      {required int offset, required int limit, String? search}) async {
    try {
      var parameter = {
        "offset": offset.toString(),
        "limit": limit.toString(),
        if (search != null && search.trim().isNotEmpty) "search": search
      };
      var catList =
          await apiBaseHelper.postAPICall(getCategoriesListApi, parameter);

      return catList;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }
}
