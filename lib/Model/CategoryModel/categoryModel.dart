import 'package:sellermultivendor/Widget/parameterString.dart';

class CategoryModel {
  String? id, name, image, banner;
  List<CategoryModel>? children;
  bool? state;
  CategoryModel(
      {this.id, this.name, this.children, this.state, this.image, this.banner});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[Id],
      name: json[Name],
      state: json['state'] != null ? json['state']['disabled'] ?? false : null,
      children: json['children'] != null
          ? List<CategoryModel>.from(
              json['children'].map((x) => CategoryModel.fromJson(x)),
            )
          : null,
      image: json['image'] ?? "",
      banner: json['banner'] ?? "",
    );
  }
}
