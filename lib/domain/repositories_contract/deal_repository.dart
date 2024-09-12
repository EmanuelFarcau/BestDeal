import 'package:dartz/dartz.dart';
import 'package:deal_hunter/core/errors/failures.dart';
import 'package:deal_hunter/domain/entities/deal_entity.dart';
import 'package:deal_hunter/domain/entities/location_entity.dart';

abstract class DealRepository {
  Future<Either<Failure, void>> addDealToDatabase(DealEntity deal);

  Future<Either<Failure, List<DealEntity>>> checkBestDealInRange({
   required List<LocationEntity> areaLocations,
   required String barcode,
  });
}
