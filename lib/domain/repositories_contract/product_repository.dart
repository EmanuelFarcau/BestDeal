import 'package:dartz/dartz.dart';
import 'package:deal_hunter/core/errors/failures.dart';
import 'package:deal_hunter/data/models/product_model.dart';
import 'package:deal_hunter/domain/entities/product_entity.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductModel?>> doesProductExist(String barcode);

  Future<Either<Failure, ProductEntity>> addProductToDatabase(
      ProductEntity product);

  Future<Either<Failure, ProductModel?>> doesProductExist2(String barcode);

  Future<Either<Failure, ProductEntity>> addProductToDatabase2(
      ProductEntity product);
}
