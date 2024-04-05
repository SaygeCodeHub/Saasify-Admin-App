import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';
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

  String selectedCategory = '';

  FutureOr<void> _addCoupon(
      AddCoupon event, Emitter<CouponsAndDiscountsStates> emit) async {
    emit(AddingCoupon());
    try {
      DocumentReference couponsRef = await firebaseService
          .getCouponAndDiscountsCollectionRef()
          .add(event.addCouponMap.toMap());
      if (couponsRef.id.isNotEmpty) {
        emit(CouponAdded(successMessage: 'Coupon added successfully'));
      } else {
        emit(CouponNotAdded(
            errorMessage: 'Could not add coupon. Please try again!'));
      }
    } catch (e) {
      emit(CouponNotAdded(errorMessage: 'Error adding coupon: $e'));
    }
  }
}
