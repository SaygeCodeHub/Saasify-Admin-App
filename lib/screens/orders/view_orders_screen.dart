import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/orders/orders_bloc.dart';
import 'package:saasify/bloc/orders/orders_event.dart';
import 'package:saasify/bloc/orders/orders_state.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/screens/orders/widgets/view_orders_section.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import 'package:saasify/utils/error_display.dart';

class ViewOrdersScreen extends StatelessWidget {
  const ViewOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<OrdersBloc>().add(FetchOrders());
    return SkeletonScreen(
      appBarTitle: 'Orders',
      bodyContent: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is FetchingOrders) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersFetched) {
            if (state.ordersList.isNotEmpty) {
              return ViewOrdersSection(ordersList: state.ordersList);
            } else {
              return const Center(child: Text('No data found!'));
            }
          } else if (state is OrdersNotFetched) {
            return Center(
              child: ErrorDisplay(
                  text: state.errorMessage,
                  buttonText: 'Could not fetch orders. Please try again!',
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  }),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      bottomBarButtons: const [],
    );
  }
}
