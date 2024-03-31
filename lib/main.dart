import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/authentication/authentication_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/companies/companies_bloc.dart';
import 'package:saasify/bloc/customers/customer_bloc.dart';
import 'package:saasify/bloc/imagePicker/image_picker_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/screens/authentication/auth/authentication_screen.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'cache/cache.dart';
import 'configs/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CustomerCache.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (context) => AuthenticationBloc()),
        BlocProvider(lazy: false, create: (context) => CategoryBloc()),
        BlocProvider(lazy: false, create: (context) => ProductBloc()),
        BlocProvider(lazy: false, create: (context) => CompaniesBloc()),
        BlocProvider(lazy: false, create: (context) => CustomerBloc()),
        BlocProvider(lazy: false, create: (context) => ImagePickerBloc()),
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
                  return snapshot.data ?? AuthenticationScreen();
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}

Future<Widget> getInitialScreen() async {
  final isLoggedIn = CustomerCache.getUserLoggedIn() ?? false;
  return isLoggedIn ? const HomeScreen() : AuthenticationScreen();
}
