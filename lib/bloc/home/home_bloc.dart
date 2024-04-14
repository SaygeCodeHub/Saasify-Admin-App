import 'package:bloc/bloc.dart';
import 'package:saasify/bloc/home/home_events.dart';
import 'package:saasify/bloc/home/home_state.dart';

import '../../services/firebase_services.dart';
import '../../services/service_locator.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  HomeState get initialState => HomeScreenInitialised();
  final firebaseService = getIt<FirebaseServices>();

  HomeBloc() : super(HomeScreenInitialised()) {
    on<InitializeHomeScreen>((event, emit) {
      emit(HomeScreenInitialised());
    });
  }
}
