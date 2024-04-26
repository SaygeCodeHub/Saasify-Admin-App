import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/authentication/authentication_bloc.dart';
import 'package:saasify/bloc/authentication/authentication_state.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/companies/companies_bloc.dart';
import 'package:saasify/bloc/couponsAndDiscounts/coupons_and_discounts_bloc.dart';
import 'package:saasify/bloc/customers/customer_bloc.dart';
import 'package:saasify/bloc/home/home_bloc.dart';
import 'package:saasify/bloc/home/home_events.dart';
import 'package:saasify/bloc/imagePicker/image_picker_bloc.dart';
import 'package:saasify/bloc/orders/orders_bloc.dart';
import 'package:saasify/bloc/pos/pos_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/suppliers/supplier_bloc.dart';
import 'package:saasify/configs/hive_setup.dart';
import 'package:saasify/screens/authentication/auth/authentication_screen.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/screens/userProfile/user_company_setup_screen.dart';
import 'package:saasify/services/service_locator.dart';
import 'bloc/authentication/authentication_event.dart';
import 'configs/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  setupHive();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              lazy: false,
              create: (context) =>
                  AuthenticationBloc()..add(CheckActiveSession())),
          BlocProvider(
              lazy: false,
              create: (context) => HomeBloc()..add(SyncToServer())),
          BlocProvider(lazy: false, create: (context) => CategoryBloc()),
          BlocProvider(lazy: false, create: (context) => ProductBloc()),
          BlocProvider(lazy: false, create: (context) => CompaniesBloc()),
          BlocProvider(lazy: false, create: (context) => CustomerBloc()),
          BlocProvider(lazy: false, create: (context) => ImagePickerBloc()),
          BlocProvider(lazy: false, create: (context) => PosBloc()),
          BlocProvider(lazy: false, create: (context) => SupplierBloc()),
          BlocProvider(lazy: false, create: (context) => OrdersBloc()),
          BlocProvider(
              lazy: false, create: (context) => CouponsAndDiscountsBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Saasify',
          theme: appTheme,
          home: Scaffold(
            body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
              if (state is InActiveSession) {
                return AuthenticationScreen();
              } else if (state is UserAuthenticatedWithoutCompany) {
                return UserCompanySetupScreen();
              } else if (state is UserAuthenticated) {
                return const HomeScreen();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
        ));
  }
}
