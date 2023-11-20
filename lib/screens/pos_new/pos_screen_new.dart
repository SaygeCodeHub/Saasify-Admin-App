import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/pos_new/widgets/billing_section_two.dart';
import 'package:saasify/utils/database_util.dart';
import 'package:saasify/utils/responsive.dart';
import 'package:saasify/widgets/sidebar.dart';
import '../../bloc/pos/billing_bloc.dart';
import '../../bloc/pos/billing_event.dart';
import '../../bloc/pos/billing_state.dart';
import '../../configs/app_color.dart';
import '../../configs/app_spacing.dart';
import '../../utils/constants/string_constants.dart';
import 'widgets/products_section.dart';

class POSTwoScreen extends StatelessWidget {
  static const routeName = 'POSScreen';

  POSTwoScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    context.read<BillingBloc>().add(LoadAllOrders());
    return Scaffold(
        key: _scaffoldKey,
        drawer: const SideBar(selectedIndex: 2),
        body: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction:
                context.responsive(Axis.vertical, desktop: Axis.horizontal),
            children: [
              context.responsive(
                  Container(
                      color: AppColor.saasifyLightDeepBlue,
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: spacingSmall, horizontal: spacingLarge),
                          child: IconButton(
                              onPressed: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                              iconSize: 30,
                              icon: const Icon(Icons.menu,
                                  color: AppColor.saasifyWhite)),
                        )
                      ])),
                  desktop: const Expanded(
                    child: SideBar(selectedIndex: 2),
                  )),
              Expanded(
                flex: 5,
                child: BlocBuilder<BillingBloc, BillingStates>(
                  builder: (context, state) {
                    if (state is FetchingProductsByCategory) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LoadDataBaseOrders) {
                      if (DatabaseUtil.ordersBox.isEmpty) {
                        context.read<BillingBloc>().add(BillingInitialEvent(
                            orderIndex:
                                context.read<BillingBloc>().orderIndex));
                      }
                      return GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5),
                          itemCount: state.customerIdList.length + 1,
                          itemBuilder: (context, index) {
                            if (state.customerIdList.length == index) {
                              return Padding(
                                  padding:
                                      const EdgeInsets.all(spacingStandard),
                                  child: InkWell(
                                      onTap: () {
                                        context.read<BillingBloc>().add(
                                            BillingInitialEvent(
                                                orderIndex: -1));
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(
                                              spacingStandard),
                                          decoration: BoxDecoration(
                                            color:
                                                AppColor.saasifyLightDeepBlue,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                Text(
                                                  'Add Customer',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .tiniest
                                                      .copyWith(
                                                          color: AppColor
                                                              .saasifyWhite),
                                                ),
                                                const SizedBox(
                                                    height: spacingStandard),
                                                Expanded(
                                                  child: Image.asset(
                                                      'assets/add.png',
                                                      fit: BoxFit.fill),
                                                )
                                              ])))));
                            }
                            return Padding(
                                padding: const EdgeInsets.all(spacingStandard),
                                child: InkWell(
                                    onTap: () {
                                      context.read<BillingBloc>().orderIndex =
                                          state.customerIdList[index];
                                      context.read<BillingBloc>().add(
                                          BillingInitialEvent(
                                              orderIndex:
                                                  state.customerIdList[index]));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                AppColor.saasifyLightDeepBlue,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                            padding: const EdgeInsets.all(
                                                spacingStandard),
                                            child: Center(
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                  Text(
                                                    'Customer no. - ${state.customerIdList[index]}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .tiniest
                                                        .copyWith(
                                                            color: AppColor
                                                                .saasifyWhite),
                                                  ),
                                                  const SizedBox(
                                                      height: spacingStandard),
                                                  Expanded(
                                                    child: Image.asset(
                                                        'assets/user.png',
                                                        fit: BoxFit.fill),
                                                  )
                                                ]))))));
                          });
                    } else if (state is ProductsLoaded) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                                flex: 5,
                                child: ProductsSection(
                                    posData: state.productsByCategories)),
                            context
                                    .read<BillingBloc>()
                                    .selectedProducts
                                    .isNotEmpty
                                ? Expanded(
                                    flex: 2,
                                    child: BillingSectionTwo(
                                        posData: state.productsByCategories))
                                : const SizedBox.shrink()
                          ]);
                    } else if (state is ErrorFetchingProductsByCategory) {
                      return const Expanded(
                          child: Text(StringConstants.kNoDataAvailable));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              )
            ]));
  }
}
