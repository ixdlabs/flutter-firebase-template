import 'package:auto_route/auto_route.dart';
import 'package:flutter_firebase_template/app/auth/login_page.dart';
import 'package:flutter_firebase_template/app/home/home_page.dart';
import 'package:flutter_firebase_template/app/home/profile_page.dart';
import 'package:flutter_firebase_template/router/auth_guard.dart';

@MaterialAutoRouter(
  preferRelativeImports: false,
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage, initial: true, guards: [AuthGuard]),
    AutoRoute(page: ProfilePage, guards: [AuthGuard]),
    AutoRoute(page: LoginPage),
  ],
)
class $MainAppRouter {}
