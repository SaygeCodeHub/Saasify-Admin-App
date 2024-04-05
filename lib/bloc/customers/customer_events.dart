import 'package:saasify/models/customer/add_customer_model.dart';

abstract class CustomerEvent {}

class AddCustomer extends CustomerEvent {
  final AddCustomerModel customerModel;

  AddCustomer({required this.customerModel});
}
