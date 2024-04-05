import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/orders/orders_bloc.dart';
import 'package:saasify/bloc/orders/orders_event.dart';
import 'package:saasify/bloc/orders/orders_state.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import 'package:saasify/utils/error_display.dart';

class ViewOrders extends StatelessWidget {
  const ViewOrders({super.key});

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
            return Padding(
              padding: const EdgeInsets.all(spacingMedium),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.ordersList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(spacingSmall),
                      leading: CachedNetworkImage(
                          width: 70,
                          height: 150,
                          imageUrl: state.ordersList[index]['image'] ?? '',
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                              color: AppColors.lighterGrey,
                              height: 50,
                              child: const Icon(Icons.image, size: 20)),
                          fit: BoxFit.cover),
                      title: Text(state.ordersList[index]['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: spacingXXSmall),
                          Text(
                              'Description: ${state.ordersList[index]['description']}'),
                          Text(
                              'Quantity:  ${state.ordersList[index]['count']}'),
                          Text('Amount:  ₹ ${state.ordersList[index]['cost']}'),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 15,
                    childAspectRatio: 2),
              ),
            );
          } else if (state is OrdersNotFetched) {
            return ErrorDisplay(
                text: state.errorMessage,
                buttonText: 'Could not fetch orders. Please try again!',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                });
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      bottomBarButtons: const [],
    );
  }
}
