import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/pos/pos_event.dart';
import 'package:saasify/bloc/pos/pos_states.dart';
import 'package:saasify/cache/cache.dart';
import 'package:saasify/models/cart_model.dart';
import 'package:saasify/models/pdf/billing_details_info_model.dart';
import 'package:saasify/models/pdf/business_info_model.dart';
import 'package:saasify/models/pdf/customer_info_model.dart';
import 'package:saasify/utils/firestore_services.dart';
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
    on<PlaceOrder>(_placeOrder);
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
    List<Map<String, dynamic>> posData = [];
    for (var item in event.posDataList) {
      double amount = (item.count * item.variantCost);
      posData.add({
        'item': item.name,
        'qty': item.count.toString(),
        'price': item.variantCost.toStringAsFixed(2),
        'amount': amount.toString(),
        'variant_id': item.variantId
      });
    }
    generatePdf(
        businessInfoModel: BusinessInfoModel(
            CustomerCache.getUserContact() ?? '',
            CustomerCache.getCompanyLicenseNo() ?? '',
            CustomerCache.getCompanyGstNo() ?? '',
            CustomerCache.getUserAddress() ?? ''),
        customerInfoModel: CustomerInfoModel(
            CustomerCache.getUserName() ?? '',
            CustomerCache.getUserContact() ?? '',
            '0',
            CustomerCache.getUserAddress() ?? ''),
        billingInfoModel: BillingInfoModel(
            CustomerCache.getUserName() ?? '',
            DateTime.now().toString(),
            '1766',
            billDetailsMap['payment_method'],
            23,
            billDetailsMap['sub_total'],
            billDetailsMap['discount_amount'] ?? 0,
            billDetailsMap['tax_percentage'] ?? 0,
            billDetailsMap['tax_percentage'] ?? 0,
            billDetailsMap['grand_total']),
        items: posData);
    add(PlaceOrder(billDetailsMap: billDetailsMap, items: posData));
  }

  FutureOr<void> _placeOrder(PlaceOrder event, Emitter<PosState> emit) async {
    try {
      emit(PlacingOrder());
      Map<String, dynamic> orderData = {
        'customerInfo': {
          'name': CustomerCache.getUserName() ?? '',
          'contact': CustomerCache.getUserContact() ?? '',
          'address': CustomerCache.getUserAddress() ?? '',
          'loyalty_points': 0
        },
        'billingInfo': {
          'customerName': CustomerCache.getUserName() ?? '',
          'date': DateTime.now().toString(),
          'invoiceNumber': '1766',
          'paymentMethod': event.billDetailsMap['payment_method'],
          'subTotal': event.billDetailsMap['sub_total'],
          'discountAmount': event.billDetailsMap['discount_amount'] ?? 0,
          'sgst': event.billDetailsMap['tax_percentage'] ?? 0,
          'cgst': event.billDetailsMap['tax_percentage'] ?? 0,
          'grandTotal': event.billDetailsMap['grand_total'],
        },
        'items': event.items
      };
      if (orderData.isNotEmpty) {
        await FirebaseService()
            .getModulesCollectionRef(CustomerCache.getUserCompany() ?? '')
            .doc('pos')
            .collection('orders')
            .add(orderData);
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
