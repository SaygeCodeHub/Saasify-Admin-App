import 'package:flutter/material.dart';
import 'package:saasify/data/models/authentication/authenticate_user_model.dart';
import 'package:saasify/screens/authentication/auth/auhentication_screen.dart';
import 'package:saasify/screens/authentication/forgotPassword/forgot_password_screen.dart';
import 'package:saasify/screens/authentication/register/register_screen.dart';
import 'package:saasify/screens/authentication/updatePassword/update_password_screen.dart';
import 'package:saasify/screens/companies/widgets/addCompany/add_company_screen.dart';
import 'package:saasify/screens/companies/widgets/branches/all_branches_screen.dart';
import 'package:saasify/screens/companies/widgets/companies/all_companies_screen.dart';
import 'package:saasify/screens/form/form_screen.dart';
import 'package:saasify/screens/generalScreens/coming_soon_screen.dart';
import 'package:saasify/screens/hrms/hrms_dashboard_screen.dart';
import 'package:saasify/screens/root_screen.dart';

class AppRoutes {
  static Route routes(RouteSettings settings) {
    switch (settings.name) {
      case RootScreen.routeName:
        return _createRoute(const RootScreen());
      case AuthenticationScreen.routeName:
        return _createRoute(AuthenticationScreen());
      case RegisterScreen.routeName:
        return _createRoute(RegisterScreen());
      case ForgotPasswordScreen.routeName:
        return _createRoute(ForgotPasswordScreen());
      case UpdatePasswordScreen.routeName:
        return _createRoute(UpdatePasswordScreen(
            isVerifyToken: (settings.arguments ?? false) as bool));
      case AddCompanyScreen.routeName:
        return _createRoute(AddCompanyScreen());
      case HRMSDashboardScreen.routeName:
        return _createRoute(const HRMSDashboardScreen());
      case FormScreen.routeName:
        return _createRoute(const FormScreen());
      case AllCompaniesScreen.routeName:
        return _createRoute(AllCompaniesScreen(
            authenticateUserData: settings.arguments as AuthenticateUserData));
      case AllBranchesScreen.routeName:
        List<dynamic> args = settings.arguments as List<dynamic>;
        return _createRoute(AllBranchesScreen(
            companyName: args[0] as String, branches: args[1] as List<Branch>));
      default:
        return _createRoute(const ComingSoonScreen());
    }
  }

  static Route<dynamic> _createRoute(Widget view) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => view,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
              position: animation.drive(tween), child: child);
        });
  }
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
