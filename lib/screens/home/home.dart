import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:restart_app/restart_app.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:t_hunt/controllers/auth_controller.dart';
import 'package:t_hunt/screens/authentication/login.dart';
import 'package:t_hunt/screens/clips/create_clips.dart';
import 'package:t_hunt/screens/clips/median_screen.dart';
import 'package:t_hunt/screens/feed/feed.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  late PersistentTabController _controller;

  final controller = PersistentTabController(initialIndex: 0);
  List<Widget> _buildScreens() {
    return [
      FeedScreen(),
      Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Settings"),
            ElevatedButton(
                onPressed: () {
                  ref.watch(authControllerProvider.notifier).signOut(context);
                },
                child: Text("Sign Out")),
          ],
        ),
      )),
      CreateClips(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider);
    return currentUser.when(
      data: (data) {
        if (data == null) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return PersistentTabView(
          context,
          controller: controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          padding: NavBarPadding.only(bottom: 0),
          backgroundColor:
              Color.fromARGB(0, 255, 255, 255), // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: const Color.fromARGB(0, 255, 255, 255),
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle
              .style1, // Choose the nav bar style with this property.
        );
      },
      error: (e, st) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(e.toString()),
            ),
          ),
        );
      },
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
