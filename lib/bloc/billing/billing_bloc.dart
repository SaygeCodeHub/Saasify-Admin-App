import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/billing/billing_event.dart';
import 'package:saasify/bloc/billing/billing_state.dart';

class BillingBloc extends Bloc<BillingEvent, BillingState> {
  BillingState get initialState => BillingInitial();

  BillingBloc() : super(BillingInitial()) {}
}
