import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/configs/app_color.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/pos_new/widgets/billing_section.dart';
import 'package:saasify/screens/pos_new/widgets/unsettled_tabs.dart';
import 'package:saasify/utils/progress_bar.dart';
import 'package:saasify/utils/responsive.dart';
import 'package:saasify/widgets/custom_alert_box.dart';
import 'package:saasify/widgets/sidebar.dart';
import 'package:saasify/widgets/top_bar.dart';
import '../../bloc/pos/billing_bloc.dart';
import '../../bloc/pos/billing_event.dart';
import '../../bloc/pos/billing_state.dart';
import '../../utils/constants/string_constants.dart';
import 'widgets/products_section.dart';

class POSScreen extends StatelessWidget {
  static const routeName = 'POSScreen';

  POSScreen({super.key});

  final _formKey = GlobalKey<FormState>();
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
              context.responsive(BlocBuilder<BillingBloc, BillingStates>(
                builder: (context, state) {
                  if (state is FetchingProductsByCategory ||
                      state is ErrorFetchingProductsByCategory ||
                      state is ProductsLoaded) {
                    return TopBar(scaffoldKey: _scaffoldKey, headingText: '');
                  } else if (state is LoadDataBaseOrders) {
                    return TopBar(
                        scaffoldKey: _scaffoldKey,
                        headingText: StringConstants.kUnsettledTabs);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
                  desktop: const Expanded(
                    child: SideBar(selectedIndex: 2),
                  )),
              Expanded(
                  flex: 5,
                  child: BlocConsumer<BillingBloc, BillingStates>(
                      listener: (context, state) {
                    if (state is SettlingOrder) {
                      ProgressBar.show(context);
                    }
                    if (state is OrderSettled) {
                      ProgressBar.dismiss(context);
                      showDialog(
                          context: context,
                          builder: (context) => CustomAlertDialog(
                              title: StringConstants.kSuccess,
                              message: state.message,
                              primaryButtonTitle: StringConstants.kOk,
                              primaryOnPressed: () {
                                Navigator.pop(context);
                                context
                                    .read<BillingBloc>()
                                    .add(LoadAllOrders());
                              }));
                    }
                    if (state is ErrorSettlingOrder) {
                      ProgressBar.dismiss(context);
                      showDialog(
                          context: context,
                          builder: (context) => CustomAlertDialog(
                              title: StringConstants.kSomethingWentWrong,
                              message: state.message,
                              primaryButtonTitle: StringConstants.kOk,
                              primaryOnPressed: () {
                                Navigator.pop(context);
                              }));
                    }
                    if (state is ErrorFetchingProductsByCategory) {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return CustomAlertDialog(
                                title: StringConstants.kSomethingWentWrong,
                                message: state.message,
                                primaryButtonTitle: StringConstants.kOk,
                                primaryOnPressed: () {
                                  Navigator.pop(ctx);
                                });
                          });
                    }
                  }, buildWhen: (prev, curr) {
                    return curr is FetchingProductsByCategory ||
                        curr is ProductsLoaded ||
                        curr is LoadDataBaseOrders ||
                        curr is ErrorFetchingProductsByCategory;
                  }, builder: (context, state) {
                    if (state is FetchingProductsByCategory) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LoadDataBaseOrders) {
                      log(state.customerIdList.toString());
                      return UnsettledTabs(
                          customerIdList: state.customerIdList,
                          customerData: state.customerData);
                    } else if (state is ProductsLoaded) {
                      if (state.productsByCategories.isNotEmpty) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: ProductsSection(
                                      productsByCategories:
                                          state.productsByCategories,
                                      categoryList: state.productsByCategories
                                          .map((e) =>
                                              e.categoryName
                                                  .trim()[0]
                                                  .toUpperCase() +
                                              e.categoryName
                                                  .trim()
                                                  .substring(1)
                                                  .toLowerCase())
                                          .toList())),
                              context
                                      .read<BillingBloc>()
                                      .customer
                                      .productList
                                      .isNotEmpty
                                  ? Expanded(
                                      flex: 2,
                                      child: BillingSection(
                                          productsByCategories:
                                              state.productsByCategories,
                                          formKey: _formKey))
                                  : const SizedBox.shrink()
                            ]);
                      } else {
                        return Center(
                            child: Text(StringConstants.kNoDataAvailable,
                                style: Theme.of(context)
                                    .textTheme
                                    .tinier
                                    .copyWith(
                                        color: AppColor.saasifyLightGrey)));
                      }
                    } else if (state is ErrorFetchingProductsByCategory) {
                      return Center(
                          child: Text(StringConstants.kNoDataAvailable,
                              style: Theme.of(context)
                                  .textTheme
                                  .tinier
                                  .copyWith(color: AppColor.saasifyLightGrey)));
                    } else {
                      return const SizedBox.shrink();
                    }
                  }))
            ]));
  }
}