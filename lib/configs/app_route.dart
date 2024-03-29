import 'package:flutter/material.dart';

import '../screens/authentication/auth/authentication_screen.dart';

class AppRoutes {
  static Route<dynamic> routes(RouteSettings settings) {
    final routeBuilders = <String, WidgetBuilder>{
      AuthenticationScreen.routeName: (_) => AuthenticationScreen(),
    };

    WidgetBuilder builder = routeBuilders[settings.name] ??
        routeBuilders[AuthenticationScreen.routeName]!;
    return _createRoute(builder);
  }

  static PageRouteBuilder<dynamic> _createRoute(WidgetBuilder builder) {
    return PageRouteBuilder<dynamic>(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
              Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.ease))),
          child: child,
        );
      },
    );
  }
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
