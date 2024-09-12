import 'package:dartz/dartz.dart';
import 'package:deal_hunter/core/errors/failures.dart';
import 'package:deal_hunter/data/models/location_model.dart';
import 'package:deal_hunter/domain/entities/location_entity.dart';

abstract class LocationRepository {
  Future<Either<dynamic, List<LocationModel>>> checkLocationsInRange(
      double x, double y, bool areaLocations);

  Future<Either<Failure, String>> addLocationToDatabase(
      LocationEntity location);

  Future<Either<Failure, String>> addCurrentLocationToDatabase();
}
