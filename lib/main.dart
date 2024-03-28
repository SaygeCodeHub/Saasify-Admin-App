import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/authentication/authentication_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/companies/companies_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/screens/authentication/auth/auth_web_screen.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'cache/Cache.dart';
import 'configs/app_theme.dart';
import 'dependency_injection.dart';
import 'firebase_options.dart';
import 'utils/global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Cache.init();
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    isMobile = MediaQuery.of(context).size.width < mobileBreakPoint;

    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (context) => AuthenticationBloc()),
        BlocProvider(lazy: false, create: (context) => CategoryBloc()),
        BlocProvider(lazy: false, create: (context) => ProductBloc()),
        BlocProvider(lazy: false, create: (context) => CompaniesBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Saasify',
        theme: appTheme,
        home: Scaffold(
          body: FutureBuilder<Widget>(
            future: getInitialScreen(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data ?? const AuthWebScreen();
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<Widget> getInitialScreen() async {
  final isLoggedIn = Cache.getUserLoggedIn() ?? false;
  return isLoggedIn ? const HomeScreen() : const AuthWebScreen();
}
