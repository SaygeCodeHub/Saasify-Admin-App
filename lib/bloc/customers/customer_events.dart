import '../../models/customer/add_customer_model.dart'; // Import path might differ

abstract class CustomerEvent {}

class AddCustomer extends CustomerEvent {
  final AddCustomerModel customerModel;

  AddCustomer({required this.customerModel});
}
