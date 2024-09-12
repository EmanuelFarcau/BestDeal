// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/repositories_impl/deal_repository_impl.dart' as _i1012;
import '../../data/repositories_impl/location_repository_impl.dart' as _i50;
import '../../data/repositories_impl/login_repository_impl.dart' as _i832;
import '../../data/repositories_impl/product_repository_impl.dart' as _i406;
import '../../data/repositories_impl/scan_repository_impl.dart' as _i287;
import '../../domain/repositories_contract/deal_repository.dart' as _i496;
import '../../domain/repositories_contract/location_repository.dart' as _i422;
import '../../domain/repositories_contract/login_repository.dart' as _i672;
import '../../domain/repositories_contract/product_repository.dart' as _i1034;
import '../../domain/repositories_contract/scan_repository.dart' as _i1029;
import '../../domain/usecases/product_details_usecase.dart' as _i636;
import '../../presentation/pages/login/bloc/login_bloc.dart' as _i308;
import '../../presentation/pages/product_details/bloc/product_details_bloc.dart'
    as _i729;
import '../../presentation/pages/scan/bloc/scan_bloc.dart' as _i597;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i496.DealRepository>(() => _i1012.DealRepositoryImpl());
    gh.singleton<_i672.LoginRepository>(() => _i832.LoginRepositoryImpl());
    gh.singleton<_i1029.ScanRepository>(() => _i287.ScanRepositoryImpl());
    gh.singleton<_i1034.ProductDetailsRepository>(
        () => _i406.ProductDetailsRepositoryImpl());
    gh.singleton<_i597.ScanBloc>(
        () => _i597.ScanBloc(gh<_i1029.ScanRepository>()));
    gh.singleton<_i422.LocationRepository>(() => _i50.LocationRepositoryImpl());
    gh.singleton<_i636.ProductDetailsUsecase>(() => _i636.ProductDetailsUsecase(
          gh<_i1034.ProductDetailsRepository>(),
          gh<_i422.LocationRepository>(),
          gh<_i496.DealRepository>(),
        ));
    gh.singleton<_i308.LoginBloc>(
        () => _i308.LoginBloc(gh<_i672.LoginRepository>()));
    gh.singleton<_i729.ProductDetailsBloc>(
        () => _i729.ProductDetailsBloc(gh<_i636.ProductDetailsUsecase>()));
    return this;
  }
}
