import 'package:auto_route/auto_route.dart';
import 'package:flutter_firebase_template/app/home/home_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage, initial: true),
  ],
)
class $MainAppRouter {}
