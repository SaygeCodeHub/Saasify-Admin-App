import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/pos/pos_event.dart';
import 'package:saasify/bloc/pos/pos_states.dart';
import 'package:saasify/cache/cache.dart';
import 'package:saasify/models/cart_model.dart';
import 'package:saasify/models/pdf/billing_details_info_model.dart';
import 'package:saasify/models/pdf/business_info_model.dart';
import 'package:saasify/models/pdf/customer_info_model.dart';
import 'package:saasify/utils/pdf/generate_pdf_service.dart';

class PosBloc extends Bloc<PosEvent, PosState> {
  PosState get initialState => PosInitial();

  PosBloc() : super(PosInitial()) {
    on<AddToCart>(_addToCart);
    on<IncrementVariantCount>(_incrementCount);
    on<DecrementVariantCount>(_decrementCount);
    on<CalculateBill>(_calculateBill);
    on<ClearCart>(_clearCart);
    on<GeneratePdf>(_generatePdf);
  }

  Map<String, dynamic> billDetailsMap = {};
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
    double discountPercent = billDetailsMap['discount_percentage'] ?? 0.0;
    double discountAmount = (netAmount * discountPercent) / 100;
    double subTotal = netAmount - discountAmount;

    double taxPercent = billDetailsMap['tax_percentage'] ?? 0.0;
    double taxes = (subTotal * taxPercent) / 100;

    double grandTotal = subTotal + taxes;

    billDetailsMap['net_amount'] = netAmount;
    billDetailsMap['discount_amount'] = discountAmount;
    billDetailsMap['sub_total'] = subTotal;
    billDetailsMap['tax'] = taxes;
    billDetailsMap['grand_total'] = grandTotal;
    emit(PosDataFetched(posDataList: event.posDataList));
  }

  FutureOr<void> _clearCart(ClearCart event, Emitter<PosState> emit) async {
    showCart = false;
    event.posDataList.clear();
    emit(PosDataFetched(posDataList: event.posDataList));
  }

  FutureOr<void> _generatePdf(GeneratePdf event, Emitter<PosState> emit) async {
    List posData = [];
    posData.add(event.posDataList);
    generatePdf(
        businessInfoModel: BusinessInfoModel(
            CustomerCache.getUserContact(),
            'license',
            CustomerCache.getCompanyGstNo(),
            CustomerCache.getUserAddress()),
        customerInfoModel: CustomerInfoModel(
            CustomerCache.getUserName(),
            CustomerCache.getUserContact(),
            'loaly points',
            CustomerCache.getUserAddress()),
        billingInfoModel: BillingInfoModel(
            CustomerCache.getUserName(),
            DateTime.now().toString(),
            '1766',
            billDetailsMap['selected_payment'],
            23,
            billDetailsMap['sub_total'],
            billDetailsMap['discount_amount'] ?? 0,
            billDetailsMap['tax_percentage'] ?? 0,
            billDetailsMap['tax_percentage'] ?? 0,
            billDetailsMap['grand_total']),
        items: []);
  }
}
