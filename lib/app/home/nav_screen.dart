// ignore_for_file: library_private_types_in_public_api, unused_field, unnecessary_null_comparison

import 'package:agora_care/app/cells/cell_screen.dart';
import 'package:agora_care/app/profile/profile_screen.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class UserNavScreen extends StatefulWidget {
  const UserNavScreen({
    Key? key,
  }) : super(key: key);

  @override
  _UserNavScreenState createState() => _UserNavScreenState();
}

class _UserNavScreenState extends State<UserNavScreen> {
  final _authController = Get.find<AuthControllers>();
  late List<Widget> _screens;

  @override
  void initState() {
    _screens = [
      //Home Screen
      _authController.liveUser.value.role != 'admin'
          ? const HomeScreen()
          : const HomeScreen(),

      // Cells Screens
      const CellsScreen(),

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
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:foodie/repository/order_respository.dart';
// import 'package:foodie/user_screen/screen/profile/my_wallet.dart';
// import 'package:get/get.dart';

// import '../../authentication_screen/screens/new_auth.dart';
// import '../../logic/const.dart';
// import '../../repository/auth.dart';
// import 'home_screen.dart';
// import 'my_order.dart';
// import 'profile/nav_profile.dart';
// import 'searchB_screen.dart';

// class UserNavScreen extends StatefulWidget {
//   static const routeName = "/nav_screen";

//   @override
//   _UserNavScreenState createState() => _UserNavScreenState();
// }

// class _UserNavScreenState extends State<UserNavScreen> {
//   final orderController = Get.find<OrderRespository>();
//   late List<Widget> _screens;
//   final controller = Get.find<AuthServices>();

//   @override
//   void initState() {
//     if (controller.status == Status.Authenticated || controller.user != null
//         ? controller.user!.isVerified!
//         : false) {
//       _screens = [
//         //Home Screen
//         HomeScreen(),

//         // Search
//         SearchScreen(),

//         // Orders
//         MyOrder(),

//         // Profile
//         NavProfile(),
//       ];
//     } else {
//       _screens = [
//         //Home Screen
//         HomeScreen(),

//         // Search
//         NewAuth(),

//         // Orders
//         NewAuth(),

//         //alternative profile screen for non registered users
//         NewAuth(),
//         // NonRegUserScreen(signUp),
//       ];
//     }

//     super.initState();
//   }

//   int _selectedIndex = 0;

//   void _selectPage(int index) {
//     if (index == 1) controller.isprofpage = false;
//     setState(() {
//       print(index);
//       _selectedIndex = index;
//     });
//   }

//   void signUp() {
//     setState(() {
//       print('here!!!!');
//       _screens = [
//         //Home Screen
//         HomeScreen(),

//         // Search
//         NewAuth(),

//         // Orders
//         NewAuth(),
//         // NonRegUserSignup(),

//         //alternative profile screen for non registered users
//         NewAuth(),
//       ];
//     });
//   }

//   void checkSignIn() {
//     setState(() {
//       if (controller.user != null ? controller.user!.isVerified! : false)
//         _screens = [
//           //Home Screen
//           HomeScreen(),

//           // Search
//           MyWallet(),

//           // Orders
//           MyOrder(),

//           // Profile
//           NavProfile(),
//         ];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (controller.thankYouRoute >= 0) {
//       _selectPage(controller.thankYouRoute);
//       controller.updateThankyouRoute(-1);
//     }
//     checkSignIn();
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//         child: BottomNavigationBar(
//           onTap: _selectPage,
//           backgroundColor: Colors.transparent,
//           unselectedItemColor: Colors.grey,
//           selectedItemColor: UIData.kbrightColor,
//           currentIndex: _selectedIndex,
//           // type: BottomNavigationBarType.fixed,
//           items: [
//             BottomNavigationBarItem(
//               backgroundColor: Theme.of(context).bottomAppBarColor,
//               icon: Icon(Icons.home_outlined),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               backgroundColor: Theme.of(context).bottomAppBarColor,
//               icon: Icon(Icons.account_balance_wallet_outlined),
//               label: 'Wallet',
//             ),
//             BottomNavigationBarItem(
//               backgroundColor: Theme.of(context).bottomAppBarColor,
//               icon: Icon(Icons.receipt),
//               label: 'Orders',
//             ),
//             BottomNavigationBarItem(
//               backgroundColor: Theme.of(context).bottomAppBarColor,
//               icon: Icon(Icons.person_outlined),
//               label: 'Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
