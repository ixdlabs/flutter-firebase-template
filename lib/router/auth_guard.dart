import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/providers/auth_provider.dart';
import 'package:flutter_firebase_template/router/router.gr.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthGuard extends AutoRedirectGuard {
  late bool isLoggedIn = false;

  AuthGuard(WidgetRef ref) {
    Log.d("Creating new authguard");
    ref.read(authStateChangesProvider.stream).listen((authState) {
      Log.d("Reevaluating authguard because auth state changed");
      isLoggedIn = authState != null;
      reevaluate();
    });
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (isLoggedIn) {
      resolver.next();
    } else {
      redirect(const LoginRoute(), resolver: resolver);
    }
  }

  @override
  Future<bool> canNavigate(RouteMatch route) async {
    return !isLoggedIn;
  }
}
