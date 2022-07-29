import 'package:auto_route/auto_route.dart';
import 'package:flutter_firebase_template/app/auth/login_page.dart';
import 'package:flutter_firebase_template/app/auth/splash_page.dart';
import 'package:flutter_firebase_template/app/home/home_page.dart';
import 'package:flutter_firebase_template/app/auth/profile_page.dart';

@MaterialAutoRouter(
  preferRelativeImports: false,
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: HomePage),
    AutoRoute(page: ProfilePage),
    AutoRoute(page: LoginPage),
  ],
)
class $MainAppRouter {}
