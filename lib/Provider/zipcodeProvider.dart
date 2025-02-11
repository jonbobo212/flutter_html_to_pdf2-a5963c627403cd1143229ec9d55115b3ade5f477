import 'package:flutter/material.dart';
import '../Model/ZipCodesModel/ZipCodeModel.dart';
import '../Repository/zipcodeRepositry.dart';
import '../Screen/AddProduct/Add_Product.dart';
import '../Screen/EditProduct/EditProduct.dart';

enum ProductAction { addProduct, editProduct, signup }

class ZipcodeProvider extends ChangeNotifier {
  int offset = 0;
  int total = 0;
  String errorMessage = '';
  String searchString = '';

  List<ZipCodeModel> zipcodeList = [];

  Future<bool> setZipCode(ProductAction productfrom,
      {bool isRefresh = true}) async {
    if (isRefresh) {
      offset = 0;

      if (productfrom == ProductAction.addProduct) {
        addProvider!.zipSearchList.clear();
      } else if (productfrom == ProductAction.signup) {
        zipcodeList.clear();
      } else {
        editProvider!.zipSearchList.clear();
      }
      notifyListeners();
    } else {
      if (productfrom == ProductAction.addProduct) {
        if (total >= addProvider!.zipSearchList.length) {
          return false;
        }
      } else if (productfrom == ProductAction.signup) {
        if (total >= zipcodeList.length) {
          return false;
        }
      } else {
        if (total >= editProvider!.zipSearchList.length) {
          return false;
        }
      }
      notifyListeners();
    }
    try {
      var result = await ZipcodeRepository.setZipCode(
          offset: offset, limit: 10, search: searchString);
      bool error = result['error'];
      errorMessage = result['message'];
      if (!error) {
        total = int.parse(result["total"].toString());
        if (offset < total) {
          var data = result['data'];
          if (productfrom == ProductAction.addProduct) {
            addProvider!.zipSearchList.addAll((data as List)
                .map((data) => ZipCodeModel.fromJson(data))
                .toList());
          } else if (productfrom == ProductAction.signup) {
            zipcodeList.addAll((data as List)
                .map((data) => ZipCodeModel.fromJson(data))
                .toList());
          } else {
            editProvider!.zipSearchList.addAll((data as List)
                .map((data) => ZipCodeModel.fromJson(data))
                .toList());
          }
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
