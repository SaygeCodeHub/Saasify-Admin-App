import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/pos/pos_event.dart';
import 'package:saasify/bloc/pos/pos_states.dart';
import 'package:saasify/cache/company_cache.dart';
import 'package:saasify/cache/user_cache.dart';
import 'package:saasify/enums/firestore_collections_enum.dart';
import 'package:saasify/models/pos_model.dart';
import 'package:saasify/models/orders/orders_model.dart';
import 'package:saasify/models/pdf/billing_details_info_model.dart';
import 'package:saasify/models/pdf/business_info_model.dart';
import 'package:saasify/models/pdf/customer_info_model.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/pdf/generate_pdf_service.dart';

class PosBloc extends Bloc<PosEvent, PosState> {
  PosState get initialState => PosInitial();
  final BillDetails billDetails = getIt<BillDetails>();
  final firebaseService = getIt<FirebaseServices>();

  PosBloc() : super(PosInitial()) {
    on<AddToCart>(_addToCart);
    on<IncrementVariantCount>(_incrementCount);
    on<DecrementVariantCount>(_decrementCount);
    on<CalculateBill>(_calculateBill);
    on<ClearCart>(_clearCart);
    on<GeneratePdf>(_generatePdf);
    on<PlaceOrder>(_placeOrder);
  }

  bool showCart = false;

  FutureOr<void> _addToCart(AddToCart event, Emitter<PosState> emit) {
    showCart = true;
    for (var item in event.posDataList) {
      item.cost = item.variantCost * item.count;
    }
    add(CalculateBill(posDataList: event.posDataList));
    emit(PosDataFetched(posDataList: event.posDataList));
  }

  FutureOr<void> _incrementCount(
      IncrementVariantCount event, Emitter<PosState> emit) {
    int selectedVariantIndex = event.selectedVariantIndex;

    if (selectedVariantIndex >= 0 &&
        selectedVariantIndex < event.posDataList.length) {
      PosModel itemToIncrement = event.posDataList[selectedVariantIndex];
      itemToIncrement.count++;
      itemToIncrement.cost =
          itemToIncrement.variantCost * itemToIncrement.count;
    }
    add(CalculateBill(posDataList: event.posDataList));
    emit(PosDataFetched(posDataList: event.posDataList));
  }

  FutureOr<void> _decrementCount(
      DecrementVariantCount event, Emitter<PosState> emit) async {
    int selectedVariantIndex = event.selectedVariantIndex;

    if (selectedVariantIndex >= 0 &&
        selectedVariantIndex < event.posDataList.length) {
      PosModel itemToIncrement = event.posDataList[selectedVariantIndex];
      itemToIncrement.count--;
      itemToIncrement.cost =
          itemToIncrement.variantCost * itemToIncrement.count;
      if (itemToIncrement.count == 0) {
        event.posDataList.removeAt(selectedVariantIndex);
      }
      if (event.posDataList.isEmpty) {
        showCart = false;
        billDetails.toJson().clear();
      }
    }
    add(CalculateBill(posDataList: event.posDataList));
    emit(PosDataFetched(posDataList: event.posDataList));
  }

  FutureOr<void> _calculateBill(
      CalculateBill event, Emitter<PosState> emit) async {
    double netAmount = 0.0;
    double totalCost = 0.0;

    for (var cartItem in event.posDataList) {
      totalCost += cartItem.cost;
    }

    netAmount = totalCost;
    double discountPercent = billDetails.discountPercentage ?? 0.0;
    double discountAmount = (netAmount * discountPercent) / 100;
    double subTotal = netAmount - discountAmount;

    double taxPercent = billDetails.taxPercentage ?? 0.0;
    double taxes = (subTotal * taxPercent) / 100;

    double grandTotal = subTotal + taxes;

    billDetails.netAmount = netAmount;
    billDetails.discount = discountAmount;
    billDetails.subTotal = subTotal;
    billDetails.tax = taxes;
    billDetails.grandTotal = grandTotal;
    emit(PosDataFetched(posDataList: event.posDataList));
  }

  FutureOr<void> _clearCart(ClearCart event, Emitter<PosState> emit) async {
    showCart = false;
    event.posDataList.clear();
    emit(PosDataFetched(posDataList: event.posDataList));
  }

  FutureOr<void> _generatePdf(GeneratePdf event, Emitter<PosState> emit) async {
    generatePdf(
        businessInfoModel: BusinessInfoModel(
            await CompanyCache.getUserContact() ?? '',
            await CompanyCache.getCompanyLicenseNo() ?? '',
            await CompanyCache.getCompanyGstNo() ?? '',
            await CompanyCache.getUserAddress() ?? ''),
        customerInfoModel: CustomerInfoModel(
            name: await UserCache.getUsername() ?? '',
            customerContact: await CompanyCache.getUserContact() ?? '',
            customerAddress: await CompanyCache.getUserAddress() ?? '',
            loyaltyPoints: '0'),
        billingInfoModel: BillingInfoModel(
            await UserCache.getUsername() ?? '',
            DateTime.now().toString(),
            '1766',
            billDetails.selectedPaymentMethod,
            23,
            billDetails.subTotal,
            billDetails.discount ?? 0,
            billDetails.taxPercentage ?? 0,
            billDetails.taxPercentage ?? 0,
            billDetails.grandTotal),
        items: event.posDataList);
    add(PlaceOrder(items: event.posDataList));
  }

  FutureOr<void> _placeOrder(PlaceOrder event, Emitter<PosState> emit) async {
    try {
      emit(PlacingOrder());
      List<Map<String, dynamic>> orderItemList =
          event.items.map((item) => item.toJson()).toList();
      Orders order = Orders(
          customerInfo: CustomerInfoModel(
              name: await UserCache.getUsername() ?? '',
              customerContact: await CompanyCache.getUserContact() ?? '',
              customerAddress: await CompanyCache.getUserAddress() ?? ''),
          billingInfo: BillingInfo(
              customerName: await UserCache.getUsername() ?? '',
              date: DateTime.now().toString(),
              invoiceNumber: '1766',
              paymentMethod: billDetails.selectedPaymentMethod.toString(),
              subTotal: billDetails.subTotal ?? 0.0,
              grandTotal: billDetails.grandTotal ?? 0.0,
              sgst: billDetails.taxPercentage ?? 0.0,
              cgst: billDetails.taxPercentage ?? 0.0,
              discountAmount: billDetails.discount ?? 0.0),
          items: orderItemList);
      DocumentReference orderRef = await firebaseService
          .getCompaniesDocRef()
          .collection(FirestoreCollection.orders.collectionName)
          .add(order.toJson());
      if (orderRef.id.isNotEmpty) {
        emit(OrderPlaced(successMessage: 'Order placed successfully!'));
      } else {
        emit(OrderNotPlaced(
            errorMessage: 'Could not place order. Please try again!'));
      }
    } catch (e) {
      emit(OrderNotPlaced(errorMessage: 'Error: ${e.toString()}'));
    }
  }
}
