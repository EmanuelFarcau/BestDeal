import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:deal_hunter/core/errors/failures.dart';
import 'package:deal_hunter/data/models/product_model.dart';
import 'package:deal_hunter/domain/entities/product_entity.dart';
import 'package:deal_hunter/domain/repositories_contract/product_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Singleton(as: ProductDetailsRepository)
class ProductDetailsRepositoryImpl extends ProductDetailsRepository {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference dealsCollection =
      FirebaseFirestore.instance.collection('deals');

  final SupabaseClient _supabaseClient = Supabase.instance.client;


  @override
  Future<Either<Failure, ProductModel?>> doesProductExist(
      String barcode) async {
    try {
      final snapshot = await productsCollection.doc(barcode).get();


      if (snapshot.exists) {
        final productData = snapshot.data() as Map<String, dynamic>;
        final product = ProductModel.fromJson(productData);
        return Right(product);
      } else {
        return const Right(null);
      }
    } catch (e) {
      return Left(FirebaseFailure("Error from firebase: $e"));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> addProductToDatabase(
      ProductEntity product) async {
    try {
      final Map<String, dynamic> productData = product.toJson();

      await productsCollection.doc(product.barcode).set(productData);

      return Right(product);
    } catch (e) {
      return Left(FirebaseFailure('Error adding product: $e'));
    }
  }

  @override
  Future<Either<Failure, ProductModel?>> doesProductExist2(String barcode) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select()
          .eq('barcode', barcode);

      // if (response.er ) {
      //   return Left(FirebaseFailure('Error fetching product: ${response.error!.message}'));
      // }

      if (response.isNotEmpty) {
        final product = ProductModel.fromJson(response.single);
        return Right(product);
      } else {
        return const Right(null);
      }
    } catch (e) {
      return Left(FirebaseFailure("Error from Supabase: $e"));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> addProductToDatabase2(ProductEntity product) async {
    try {
      final Map<String, dynamic> productData = product.toJson();

      final response = await _supabaseClient
          .from('products')
          .insert(productData);


      if (response.error != null) {
        return Left(FirebaseFailure('Error adding product: ${response.error!.message}'));
      }

      return Right(product);
    } catch (e) {
      return Left(FirebaseFailure('Error adding product: $e'));
    }
  }
}

