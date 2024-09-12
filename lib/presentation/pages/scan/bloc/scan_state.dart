part of 'scan_bloc.dart';

@immutable
abstract class ScanState {}

class ScanInitial extends ScanState {}

class ScanSuccessState extends ScanState {
  final String barcode;

  ScanSuccessState(this.barcode);
}

class ScanLoadingState extends ScanState {}

class PermissionErrorState extends ScanState {}