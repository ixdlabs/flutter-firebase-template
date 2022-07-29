import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/router/router.gr.dart';

class AuthGuard extends AutoRedirectGuard {
  late bool isLoggedIn = false;

  void onAuthStateChange(User? user) {
    Log.d("Reevaluating authguard because auth state "
        "changed to ${user?.runtimeType}");
    isLoggedIn = user != null;
    reevaluate();
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (isLoggedIn) {
      Log.d("Continuing to next route because user is logged in");
      resolver.next();
    } else {
      Log.i("Redirecting to login page because user is not logged in");
      redirect(const LoginRoute(), resolver: resolver);
    }
  }

  @override
  Future<bool> canNavigate(RouteMatch route) async {
    return !isLoggedIn;
  }
}
