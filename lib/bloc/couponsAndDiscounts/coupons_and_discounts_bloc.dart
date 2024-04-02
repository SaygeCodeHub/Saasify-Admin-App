import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/models/couponsAndDiscounts/coupons_and_discounts.dart';
import 'package:saasify/utils/global.dart';
import 'coupons_and_discounts_event.dart';
import 'coupons_and_discounts_state.dart';

class CouponsAndDiscountsBloc
    extends Bloc<CouponsAndDiscountsEvents, CouponsAndDiscountsStates> {
  CouponsAndDiscountsStates get initialState => CouponInitial();

  CouponsAndDiscountsBloc() : super(CouponInitial()) {
    on<AddCoupon>(_addCoupon);
  }

  String selectedCategory = '';

  FutureOr<void> _addCoupon(
      AddCoupon event, Emitter<CouponsAndDiscountsStates> emit) async {
    emit(AddingCoupon());
    try {
      if (kIsOfflineModule) {
      } else {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null || user.uid.isEmpty) {
          emit(CouponNotAdded(errorMessage: 'User not authenticated.'));
        } else {
          String userId = user.uid;
          CouponsAndDiscountsModel category = CouponsAndDiscountsModel(
            couponCode: event.addCouponMap.couponCode,
            amount: event.addCouponMap.amount,
            maximumAmount: event.addCouponMap.maximumAmount,
            couponType: event.addCouponMap.couponType,
            validTill: event.addCouponMap.validTill,
          );
          Map<String, dynamic> categoryData = category.toMap();
          categoryData.remove('category_id');
          final usersRef =
              FirebaseFirestore.instance.collection('users').doc(userId);
          CollectionReference companiesRef = usersRef.collection('companies');
          QuerySnapshot snapshot = await companiesRef.get();
          String companyId = '';
          for (var doc in snapshot.docs) {
            companyId = doc.id;
          }
          final couponsRef = usersRef
              .collection('companies')
              .doc(companyId)
              .collection('modules')
              .doc('pos')
              .collection('coupons');

          couponsRef.add(categoryData);
          emit(CouponAdded(successMessage: 'Coupon added successfully'));
        }
      }
    } catch (e) {
      emit(CouponNotAdded(errorMessage: 'Error adding coupon: $e'));
    }
  }
}
