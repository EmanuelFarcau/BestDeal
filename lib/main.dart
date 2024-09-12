import 'package:deal_hunter/core/di/injectable.dart';
import 'package:deal_hunter/core/utils/constants.dart';
import 'package:deal_hunter/presentation/pages/home/home_page.dart';
import 'package:deal_hunter/presentation/pages/login/login_page.dart';
import 'package:deal_hunter/presentation/pages/product_details/product_details_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: AppKeys.supabaseInitializeUrl,
    anonKey: AppKeys.supabaseInitializeAnonKey,
  );

  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deal Hunter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
      builder: EasyLoading.init(),
      routes: {
        '/home': (context) => const HomePage(),
        '/productPage': (context) => const ProductDetailsPage(),
      },
    );
  }
}
