// ignore_for_file: library_private_types_in_public_api, unused_field, unnecessary_null_comparison, must_be_immutable

import 'package:agora_care/app/cells/admin_cell_screen.dart';
import 'package:agora_care/app/profile/admin_profile.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/widget/global_bottom_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../admin_home_screen.dart';

class AdminNavScreen extends StatefulWidget {
  int? tabIndex;
  AdminNavScreen({Key? key, this.tabIndex = 0}) : super(key: key);

  @override
  _AdminNavScreenState createState() => _AdminNavScreenState();
}

class _AdminNavScreenState extends State<AdminNavScreen> {
  final _authController = Get.find<AuthControllers>();
  late List<Widget> _screens;

  final _scaffoldState = GlobalKey();

  @override
  void initState() {
    _screens = [
      //Home Screen
      const AdminHomeScreen(),

      // Cells Screens
      const AdminCellsScreen(),

      // Profile Screen
      const AdminProfileScreen(),
    ];
    super.initState();
  }

  int _selectedIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        onTap: _selectPage,
        backgroundColor: AppColor().whiteColor,
        currentIndex: _selectedIndex,
        elevation: 20,
        key: _scaffoldState,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            icon: SvgPicture.asset(
              'assets/svgs/home.svg',
            ),
            label: '',
            tooltip: 'Home',
            activeIcon: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SvgPicture.asset('assets/svgs/home_filled.svg'),
                SvgPicture.asset('assets/svgs/home.svg'),
              ],
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            icon: SvgPicture.asset('assets/svgs/people.svg'),
            label: '',
            tooltip: 'Cells',
            activeIcon: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SvgPicture.asset('assets/svgs/people_filled.svg'),
                SvgPicture.asset('assets/svgs/people.svg'),
              ],
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            label: '',
            tooltip: 'Users',
            icon: SvgPicture.asset('assets/svgs/user-tag.svg'),
            activeIcon: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SvgPicture.asset('assets/svgs/user-tag_filled.svg'),
                SvgPicture.asset('assets/svgs/user-tag.svg'),
              ],
            ),
          )
        ],
      ),
    );
  }

  showGlobalBottomSheet(context) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColor().whiteColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      context: context,
      builder: (context) => GlobalBottomDialogue(
        back: () {
          if (kDebugMode) {
            print('back pressed');
          }
          Get.close(1);
        },
        next: () async {
          _authController.setFirstTimeButtonOpen(true);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminNavScreen(tabIndex: 2)));

          if (kDebugMode) {
            print('next pressed');
          }
        },
      ),
    );
  }
}
