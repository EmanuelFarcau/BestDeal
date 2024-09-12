import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:deal_hunter/core/errors/failures.dart';
import 'package:deal_hunter/data/models/deal_model.dart';
import 'package:deal_hunter/domain/entities/deal_entity.dart';
import 'package:deal_hunter/domain/entities/location_entity.dart';
import 'package:deal_hunter/domain/repositories_contract/deal_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: DealRepository)
class DealRepositoryImpl extends DealRepository {
  final CollectionReference dealsCollection =
      FirebaseFirestore.instance.collection('deals');

  @override
  Future<Either<Failure, void>> addDealToDatabase(DealEntity deal) async {
    try {
      final Map<String, dynamic> dealData = deal.toJson();

      await dealsCollection.add(dealData);

      return const Right(null);
    } catch (e) {
      return Left(FirebaseFailure("Eroare necunoascută: $e"));
    }
  }

  @override
  Future<Either<Failure, List<DealEntity>>> checkBestDealInRange({
    required List<LocationEntity> areaLocations,
    required String barcode,
  }) async {
    try {
      List<String?> locationIds =
          areaLocations.map((location) => location.id).toList();

      QuerySnapshot dealSnapshot = await dealsCollection
          .where('productBarcode', isEqualTo: barcode)
          .where('locationId', whereIn: locationIds)
          .orderBy('price')
          .get();

      List<DealModel> bestDealsInRange = dealSnapshot.docs.map((doc) {
        Map<String, dynamic> dealData = doc.data() as Map<String, dynamic>;
        dealData['id'] = doc.id;
        return DealModel.fromJson(dealData);
      }).toList();

      return Right(bestDealsInRange);
    } catch (e) {
      return Left(FirebaseFailure("Eroare necunoascută: $e"));
    }
  }
}
