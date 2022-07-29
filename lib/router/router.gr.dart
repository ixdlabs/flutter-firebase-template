// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:flutter_firebase_template/app/auth/login_page.dart' as _i4;
import 'package:flutter_firebase_template/app/auth/profile_page.dart' as _i3;
import 'package:flutter_firebase_template/app/auth/splash_page.dart' as _i1;
import 'package:flutter_firebase_template/app/home/home_page.dart' as _i2;
import 'package:flutter_firebase_template/router/auth_guard.dart' as _i7;

class MainAppRouter extends _i5.RootStackRouter {
  MainAppRouter(
      {_i6.GlobalKey<_i6.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i7.AuthGuard authGuard;

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SplashPage());
    },
    HomeRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.HomePage());
    },
    ProfileRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.ProfilePage());
    },
    LoginRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.LoginPage());
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(SplashRoute.name, path: '/'),
        _i5.RouteConfig(HomeRoute.name,
            path: '/home-page', guards: [authGuard]),
        _i5.RouteConfig(ProfileRoute.name,
            path: '/profile-page', guards: [authGuard]),
        _i5.RouteConfig(LoginRoute.name, path: '/login-page')
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i5.PageRouteInfo<void> {
  const SplashRoute() : super(SplashRoute.name, path: '/');

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '/home-page');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.ProfilePage]
class ProfileRoute extends _i5.PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: '/profile-page');

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i5.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: '/login-page');

  static const String name = 'LoginRoute';
}
