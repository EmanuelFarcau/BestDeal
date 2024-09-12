class ProductEntity {
  final String barcode;
  final String name;
  final String brand;
  final String description;
  final String imagePath;
  final double quantity;
  final int uomId;
  final int categoryId;

  ProductEntity({
    required this.barcode,
    required this.name,
    required this.brand,
    required this.description,
    required this.imagePath,
    required this.quantity,
    required this.uomId,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'brand': brand,
      'description': description,
      'image_path': imagePath,
      'quantity': quantity,
      'uom_id': uomId,
      'category_id': categoryId,
    };
  }
}
