import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/home/home_events.dart';
import 'package:saasify/bloc/home/home_state.dart';
import 'package:saasify/utils/global.dart';

import '../../services/firebase_services.dart';
import '../../services/server_data_services.dart';
import '../../services/service_locator.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  HomeState get initialState => HomeScreenInitialised();
  final firebaseService = getIt<FirebaseServices>();
  ServerDataServices serverDataServices = ServerDataServices();

  HomeBloc() : super(HomeScreenInitialised()) {
    on<InitializeHomeScreen>((event, emit) {
      emit(HomeScreenInitialised());
    });
    on<SyncToServer>(_syncServerData);
  }

  FutureOr<void> _syncServerData(
      SyncToServer event, Emitter<HomeState> emit) async {
    try {
      emit(SyncingToServer());
      if (await serverDataServices.checkIfCategoryExists()) {
        if (await serverDataServices.checkIfProductExists()) {
          if (await serverDataServices.checkIfProductVariantExists()) {
            emit(SyncedWithServer());
            firstTimeSyncingDone = true;
          } else {
            await fetchVariants(emit);
            emit(SyncedWithServer());
            firstTimeSyncingDone = true;
          }
        } else {
          await fetchProductAndVariants(emit);
        }
      } else {
        await fetchCategoryProductVariants(emit);
      }
    } catch (e) {
      emit(SyncingFailed());
    }
  }

  fetchCategoryProductVariants(Emitter<HomeState> emit) async {
    await serverDataServices.fetchAndStoreCategoriesFromServer();
    await serverDataServices.fetchAndStoreProductsFromServer();
    await serverDataServices
        .fetchAndStoreVariantsFromServer()
        .whenComplete(() => emit(SyncedWithServer()));
  }

  fetchProductAndVariants(Emitter<HomeState> emit) async {
    await serverDataServices.fetchAndStoreProductsFromServer();
    await serverDataServices
        .fetchAndStoreVariantsFromServer()
        .whenComplete(() => emit(SyncedWithServer()));
  }

  fetchVariants(Emitter<HomeState> emit) async {
    await serverDataServices
        .fetchAndStoreVariantsFromServer()
        .whenComplete(() => emit(SyncedWithServer()));
  }
}
