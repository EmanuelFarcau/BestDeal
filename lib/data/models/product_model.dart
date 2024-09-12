import 'package:deal_hunter/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.barcode,
    required super.name,
    required super.brand,
    required super.description,
    required super.imagePath,
    required super.quantity,
    required super.uomId,
    required super.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      description: json['description'] as String,
      imagePath: json['image_path'] as String,
      quantity: json['quantity'] as double,
      uomId: json['uom_id'] as int,
      categoryId: json['category_id'] as int,
    );
  }

  factory ProductModel.empty({String? barcode}) {
    return ProductModel(
      barcode: barcode ?? '',
      name: '',
      brand: '',
      description: '',
      imagePath: '',
      quantity: 0.0,
      uomId: 0,
      categoryId: 0,
    );
  }
}
