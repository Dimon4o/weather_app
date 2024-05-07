import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'config/router/router.dart';
import 'config/themes/themes.dart';
import 'data/providers/providers.dart';
import 'utils/utils.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          _switchTab(context, index, ref);
        },
        currentIndex: ref.watch(pageIndexProvider),
        items: tabs,
      ),
    );
  }

  void _switchTab(BuildContext context, int index, WidgetRef ref) {
    if (index == ref.watch(pageIndexProvider)) return;
    GoRouter router = GoRouter.of(context);
    String location = tabs[index].initialLocation;

    ref.read(pageIndexProvider.notifier).updateValue(index);
    router.go(location);
  }
}

List<MyCustomBottomNavBarItem> tabs = [
  MyCustomBottomNavBarItem(
    icon: NavbarIcon(icon: SvgPicture.asset('assets/icons/Locations.svg')),
    activeIcon: NavbarIcon(
      icon: SvgPicture.asset(
        'assets/icons/Locations.svg',
        colorFilter: ColorFilter.mode(AppColors.yellow, BlendMode.srcIn),
      ),
    ),
    label: 'Locations',
    initialLocation: RouteLocations.locationsScreen,
  ),
  MyCustomBottomNavBarItem(
    icon: NavbarIcon(icon: SvgPicture.asset('assets/icons/Forecast.svg')),
    activeIcon: NavbarIcon(
      icon: SvgPicture.asset(
        'assets/icons/Forecast.svg',
        colorFilter: ColorFilter.mode(AppColors.yellow, BlendMode.srcIn),
      ),
    ),
    label: 'Forecast',
    initialLocation: RouteLocations.forecastScreen,
  ),
  MyCustomBottomNavBarItem(
    icon: NavbarIcon(icon: SvgPicture.asset('assets/icons/Radar.svg')),
    activeIcon: NavbarIcon(
      icon: SvgPicture.asset(
        'assets/icons/Radar.svg',
        colorFilter: ColorFilter.mode(AppColors.yellow, BlendMode.srcIn),
      ),
    ),
    label: 'Radar',
    initialLocation: RouteLocations.radarScreen,
  ),
  MyCustomBottomNavBarItem(
    icon: NavbarIcon(icon: SvgPicture.asset('assets/icons/Settings.svg')),
    activeIcon: NavbarIcon(
      icon: SvgPicture.asset(
        'assets/icons/Settings.svg',
        colorFilter: ColorFilter.mode(AppColors.yellow, BlendMode.srcIn),
      ),
    ),
    label: 'Settings',
    initialLocation: RouteLocations.settingsScreen,
  ),
];

class NavbarIcon extends StatelessWidget {
  const NavbarIcon({required this.icon, super.key});
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: icon,
    );
  }
}
