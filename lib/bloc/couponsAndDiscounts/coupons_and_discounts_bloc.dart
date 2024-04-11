import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/hive_box_service.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/global.dart';
import 'coupons_and_discounts_event.dart';
import 'coupons_and_discounts_state.dart';

class CouponsAndDiscountsBloc
    extends Bloc<CouponsAndDiscountsEvents, CouponsAndDiscountsStates> {
  CouponsAndDiscountsStates get initialState => CouponInitial();
  final firebaseService = getIt<FirebaseServices>();
  Map<String, dynamic> couponsAndDiscountsMap = {};

  CouponsAndDiscountsBloc() : super(CouponInitial()) {
    on<AddCoupon>(_addCoupon);
  }

  FutureOr<void> _addCoupon(
      AddCoupon event, Emitter<CouponsAndDiscountsStates> emit) async {
    try {
      HiveBoxService.couponsBox.add(event.addCouponMap).whenComplete(() async {
        try {
          if (!kIsOfflineModule) {
            emit(AddingCoupon());
            DocumentReference couponsRef = await firebaseService
                .getCouponAndDiscountsCollectionRef()
                .add(event.addCouponMap.toMap());
            if (couponsRef.id.isNotEmpty) {
              emit(CouponAdded(successMessage: 'Coupon added successfully'));
            } else {
              emit(CouponNotAdded(
                  errorMessage: 'Could not add coupon. Please try again!'));
            }
          } else {
            if (HiveBoxService.couponsBox.isNotEmpty) {
              emit(CouponAdded(successMessage: 'Coupon added successfully'));
            } else {
              emit(CouponNotAdded(
                  errorMessage: 'Could not add coupon. Please try again!'));
            }
          }
        } catch (e) {
          emit(CouponNotAdded(
              errorMessage:
                  'An error occurred while adding the coupon & discount. Please try again!'));
        }
      });
    } catch (e) {
      if (e is HiveError) {
        emit(CouponNotAdded(
            errorMessage:
                'An error occurred while adding the coupon & discount. Please try again!'));
      } else {
        rethrow;
      }
    }
  }
}
