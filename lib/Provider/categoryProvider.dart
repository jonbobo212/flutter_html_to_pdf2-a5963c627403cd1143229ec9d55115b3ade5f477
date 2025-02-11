import 'package:flutter/material.dart';
import '../Helper/Constant.dart';
import '../Model/CategoryModel/categoryModel.dart';
import '../Repository/categoryRepositry.dart';
import '../Screen/AddProduct/Add_Product.dart';
import '../Screen/EditProduct/EditProduct.dart';

// enum ProductCategoryAction { addProduct, editProduct, signup }

class CategoryProvider extends ChangeNotifier {
  int total = 0;
  int offset = 0;
  String errorMessage = '';
  String searchString = '';
  List<CategoryModel> categoryList = [];

  Future<bool> setCategory(bool fromAddProduct, BuildContext context) async {
    try {
      var parameter = {};
      var result = await CategoryRepository.setCategory(parameter: parameter);
      bool error = result['error'];
      errorMessage = result['message'];
      if (!error) {
        var data = result['data'];
        if (fromAddProduct) {
          addProvider!.catagorylist.clear();
          addProvider!.catagorylist = (data as List)
              .map((data) => CategoryModel.fromJson(data))
              .toList();
        } else {
          editProvider!.catagorylist.clear();
          editProvider!.catagorylist = (data as List)
              .map((data) => CategoryModel.fromJson(data))
              .toList();
        }
      }
      return error;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    }
  }

  Future<bool> setCategoryList({bool isRefresh = true}) async {
    print("isrefresh----->${isRefresh.toString()}");

    if (isRefresh) {
      offset = 0;
      categoryList.clear();
      notifyListeners();
    }

    try {
      // Fetch categories from the API
      var result = await CategoryRepository.setCategoryList(
          offset: offset, limit: perPage, search: searchString);

      bool error = result['error'];
      errorMessage = result['message'];

      if (!error) {
        total = int.parse(result["total"].toString());
        offset = offset;
        if (offset < total) {
          var data = result['rows'];

          if (isRefresh) {
            categoryList.clear();
          }
          categoryList.addAll((data as List)
              .map((data) => CategoryModel.fromJson(data))
              .toList());

          offset = offset + perPage;
        }
      }

      notifyListeners();
      return error;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return true;
    }
  }
}
