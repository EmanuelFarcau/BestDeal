import 'package:deal_hunter/core/di/injectable.dart';
import 'package:deal_hunter/core/utils/constants.dart';
import 'package:deal_hunter/presentation/pages/home/scan.dart';
import 'package:deal_hunter/presentation/pages/home/settings.dart';
import 'package:deal_hunter/presentation/pages/scan/bloc/scan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const  List<Widget> _navScreens = <Widget>[
     ScanPage(),
     Settings(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ScanBloc, ScanState>(
      bloc: getIt<ScanBloc>(),
      listener: (context, state) {
        EasyLoading.dismiss();
      if (state is PermissionErrorState) {
        EasyLoading.showError(AppString.permissionErrorText);
      }
      },
        child: Scaffold(
            appBar: AppBar(
              title: const Text(AppString.homeText),
            ),
          body: Center(
            child: _navScreens.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GNav(
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: AppString.homeText,
                ),
                GButton(
                  icon: Icons.settings,
                  text: AppString.settingsText,
                ),
              ],
            ),
          ),
        ),
    ),
    );
  }
}


