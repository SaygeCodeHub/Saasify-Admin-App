import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/authentication/authentication_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/companies/companies_bloc.dart';
import 'package:saasify/bloc/imagePicker/image_picker_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/screens/authentication/auth/authentication_screen.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/utils/global.dart';
import 'cache/cache.dart';
import 'configs/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Cache.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Future<Widget> _initialScreenFuture;

  @override
  void initState() {
    super.initState();
    _initialScreenFuture = getInitialScreen();
  }

  @override
  Widget build(BuildContext context) {
    isMobile = MediaQuery.of(context).size.width < mobileBreakPoint;
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (context) => AuthenticationBloc()),
        BlocProvider(lazy: false, create: (context) => CategoryBloc()),
        BlocProvider(lazy: false, create: (context) => ProductBloc()),
        BlocProvider(lazy: false, create: (context) => CompaniesBloc()),
        BlocProvider(lazy: false, create: (context) => ImagePickerBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Saasify',
        theme: appTheme,
        home: Scaffold(
          body: FutureBuilder<Widget>(
            future: _initialScreenFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data ?? AuthenticationScreen();
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
  return isLoggedIn ? const HomeScreen() : AuthenticationScreen();
}
