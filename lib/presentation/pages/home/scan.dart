import 'package:deal_hunter/core/di/injectable.dart';
import 'package:deal_hunter/core/utils/constants.dart';
import 'package:deal_hunter/presentation/pages/product_details/add_product_details_page.dart';
import 'package:deal_hunter/presentation/pages/product_details/bloc/product_details_bloc.dart';
import 'package:deal_hunter/presentation/pages/scan/bloc/scan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ProductDetailsBloc productBloc = getIt<ProductDetailsBloc>();
  final ScanBloc scanBloc = getIt<ScanBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<ScanBloc, ScanState>(
            bloc: scanBloc,
            listener: (context, state) async {
              if (state is ScanInitial) {
                await Navigator.push<String?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ),
                ).then((value) => productBloc.add(CheckProduct(value!)));
              }
            },
          ),
          BlocListener<ProductDetailsBloc, ProductDetailsState>(
            bloc: productBloc,
            listener: (context, state) {
              EasyLoading.dismiss();

              if (state is ProductAddedState) {
                Navigator.pushReplacementNamed(context, '/productPage');
              } else if (state is ProductExistsState) {
                Navigator.pushNamed(context, '/productPage');
              } else if (state is ProductDetailsLoadingState) {
                EasyLoading.show(status: AppString.loadingText);
              } else if (state is ProductNotExistsState &&
                  state.barcode != '-1') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddProductDetailsPage(barcode: state.barcode),
                  ),
                );
              }
            },
          )
        ],
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              getIt<ScanBloc>().add(InitializeCameraEvent());
            },
            child: const Text(AppString.scanButtonText),
          ),
        ),
      ),
    );
  }
}
