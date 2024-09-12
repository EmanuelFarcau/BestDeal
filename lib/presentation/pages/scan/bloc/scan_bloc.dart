import 'package:bloc/bloc.dart';
import 'package:deal_hunter/domain/repositories_contract/scan_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'scan_event.dart';

part 'scan_state.dart';

@singleton
class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ScanRepository _scanRepository;

  ScanBloc(this._scanRepository) : super(ScanInitial()) {
    on<InitializeCameraEvent>((event, emit) async {
      final bool cameraHasPermission =
          await _scanRepository.checkPermission(Permission.camera);
      final bool locationHasPermission =
          await _scanRepository.checkPermission(Permission.location);


      if (cameraHasPermission && locationHasPermission) {
        await _scanRepository.initializeCamera();
        emit(ScanInitial());
      } else {
        emit(PermissionErrorState());
      }
    });
  }
}
