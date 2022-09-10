// ignore_for_file: library_private_types_in_public_api, unused_field, unnecessary_null_comparison, must_be_immutable, prefer_if_null_operators

import 'package:agora_care/app/consultant/consultant_messages.dart';
import 'package:agora_care/app/home/consultant_home_screen.dart';
import 'package:agora_care/app/profile/profile_screen.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ConsultantNavScreen extends StatefulWidget {
  int? tabIndex;
  ConsultantNavScreen({Key? key, this.tabIndex = 0}) : super(key: key);

  @override
  _ConsultantNavScreenState createState() => _ConsultantNavScreenState();
}

class _ConsultantNavScreenState extends State<ConsultantNavScreen> {
  final _authController = Get.find<AuthControllers>();
  late List<Widget> _screens;

  final _scaffoldState = GlobalKey();

  @override
  void initState() {
    // checkAdmin();

    _screens = [
      //Home Screen
      const ConsultantHome(),

      // Consultant Messassage Screens
      const ConsultantMessage(),

      // Profile Screen
      const ProfileScreen(),
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
            label: '',
            tooltip: 'Messages',
            icon: Icon(
              CupertinoIcons.mail,
              color: AppColor().primaryColor,
            ),
            activeIcon: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Icon(
                  CupertinoIcons.mail_solid,
                  color: AppColor().primaryColor,
                ),
                Icon(
                  CupertinoIcons.mail_solid,
                  color: AppColor().primaryColor,
                ),
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
          ),
        ],
      ),
    );
  }
}
