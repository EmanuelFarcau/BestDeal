import 'package:deal_hunter/core/di/injectable.dart';
import 'package:deal_hunter/core/utils/constants.dart';
import 'package:deal_hunter/domain/entities/product_entity.dart';
import 'package:deal_hunter/presentation/pages/product_details/best_deal_page.dart';
import 'package:deal_hunter/presentation/pages/product_details/bloc/product_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isInStore = false;

  Future<bool?> _showDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppString.inStoreText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(AppString.yesText),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(AppString.noText),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _showDialog().then((result) {
        if (result != null) {
          isInStore = result;
          //print('Dialog result: $result');
          // Do something with the result here
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.emptyString),
      ),
      body: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
        bloc: getIt<ProductDetailsBloc>(),
        buildWhen: (oldState, newState) {
          return newState is ProductReceivedState;
        },
        listener: (context, state) {
          if (state is BestDealFoundState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => BestDealPage(deal: state.deal)),
            );
          } else if (state is DealErrorState) {
            EasyLoading.showError(state.errorMessage);
          }
          else if (state is NoDealFoundState){
            EasyLoading.showInfo(state.isInStore ? AppString.bestDealFoundText : AppString.noOffersText );
          }
        },
        builder: (context, state) {
          if (state is ProductReceivedState) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                  child: buildProductDetails(state.product)),
            );
          } else {
            return Text(AppString.unexpectedErrorText);
          }
        },
      ),
    );
  }

  final TextEditingController priceController = TextEditingController();

  Widget buildProductDetails(ProductEntity? product) {
    if (product == null) {
      return const CircularProgressIndicator();
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AppString.imagePathText),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Title(
                  color: Colors.black,
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
              child: Text(product.description),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
              child: Row(
                children: [
                  Text(product.quantity.toStringAsFixed(0)),
                  const SizedBox(),
                 // Text(product.unitMeasure)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
              child: SizedBox(
                width: 150,
                child: FocusScope(
                  child: TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: AppString.priceText,
                    ),
                    enabled: isInStore,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (priceController.text.isNotEmpty) {
                  getIt<ProductDetailsBloc>().add(
                    CheckBestDealsEvent(
                      product.barcode,
                      double.tryParse(priceController.text),
                      isInStore,
                    ),
                  );
                }
                else {
                  EasyLoading.showError(AppString.noPriceErrorText);
                }
              },
              child: const Text(AppString.checkBestDeal),
            )
          ],
        ),
      ),
    );
  }
}
