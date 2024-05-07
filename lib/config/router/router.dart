import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../base_screen.dart';
import '../../screens/screens.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

class RouteLocations {
  const RouteLocations._();

  static String get locationsScreen => '/locationScreen';
  static String get forecastScreen => '/forecastScreen';
  static String get radarScreen => '/radarScreen';
  static String get settingsScreen => '/settingsScreen';

  static String get subscriptionScreen => '/subscriptionScreen';
  static String get articleScreen => '/articleScreen';
}

final router = GoRouter(
  initialLocation: RouteLocations.forecastScreen,
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
            child: ScaffoldWithNavBar(
          child: child,
        ));
      },
      routes: shellRoutes,
    ),
    // GoRoute(
    //     path: RouteLocations.subscriptionScreen,
    //     parentNavigatorKey: rootNavigatorKey,
    //     builder: FoodItemScreen.builder),
    // GoRoute(
    //     path: RouteLocations.articleScreen,
    //     parentNavigatorKey: rootNavigatorKey,
    //     builder: LoyalityScreen.builder),
  ],
);

final shellRoutes = [
  GoRoute(
      path: RouteLocations.locationsScreen,
      parentNavigatorKey: shellNavigatorKey,
      builder: LocationsScreen.builder),
  GoRoute(
      path: RouteLocations.forecastScreen,
      parentNavigatorKey: shellNavigatorKey,
      builder: ForecastScreen.builder),
  GoRoute(
      path: RouteLocations.radarScreen,
      parentNavigatorKey: shellNavigatorKey,
      builder: RadarScreen.builder),
  GoRoute(
      path: RouteLocations.settingsScreen,
      parentNavigatorKey: shellNavigatorKey,
      builder: SettingsScreen.builder),
];
