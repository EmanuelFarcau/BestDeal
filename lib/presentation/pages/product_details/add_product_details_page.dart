import 'package:deal_hunter/core/di/injectable.dart';
import 'package:deal_hunter/core/utils/constants.dart';
import 'package:deal_hunter/domain/entities/product_entity.dart';
import 'package:deal_hunter/presentation/pages/product_details/bloc/product_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductDetailsPage extends StatefulWidget {
  const AddProductDetailsPage({super.key, required this.barcode});

  final String barcode;

  @override
  State<AddProductDetailsPage> createState() => _AddProductDetailsPageState();
}

class _AddProductDetailsPageState extends State<AddProductDetailsPage> {
  final barcodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitMeasureController = TextEditingController();
  final TextEditingController categoryIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    barcodeController.text = widget.barcode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.addProductDetailsText),
      ),
      body: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
        bloc: getIt<ProductDetailsBloc>(),
        listener: (context, state) {
          if (state is ProductAddedState) {
            Navigator.pushReplacementNamed(context, '/productPage');
          }
          if (state is ProductErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: barcodeController,
                        decoration: const InputDecoration(
                          labelText: AppString.barcodeText,
                        ),
                        enabled: false,
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: AppString.productNameText,
                        ),
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: AppString.descriptionText,
                        ),
                      ),
                      TextFormField(
                        controller: quantityController,
                        decoration: const InputDecoration(
                          labelText: AppString.quantityText,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: unitMeasureController,
                        decoration: const InputDecoration(
                          labelText: AppString.unitMeasureText,
                        ),
                      ),
                      TextFormField(
                        controller: categoryIdController,
                        decoration: const InputDecoration(
                          labelText: AppString.categoryIdText,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final product = ProductEntity(
                              barcode: barcodeController.text,
                              name: nameController.text,
                              description: descriptionController.text,
                              imagePath: '1',
                              quantity:
                                  double.tryParse(quantityController.text) ??
                                      0.0,
                              uomId: 1,
                              categoryId: 2,
                              brand: '1',
                            );

                            getIt<ProductDetailsBloc>()
                                .add(AddProductToDataBase(product));
                          }
                        },
                        child: const Text(AppString.addProductText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
