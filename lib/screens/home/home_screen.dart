import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/home/home_bloc.dart';
import 'package:saasify/bloc/home/home_events.dart';
import 'package:saasify/bloc/home/home_state.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/screens/home/widgets/feature_card_widget.dart';
import 'package:saasify/screens/home/widgets/logout_widget.dart';
import 'package:saasify/screens/home/widgets/open_tabs_widget.dart';
import 'package:saasify/screens/home/widgets/settings_widget.dart';
import 'package:saasify/screens/home/widgets/user_avatar_widget.dart';
import 'package:saasify/utils/device_util.dart';
import 'package:saasify/utils/progress_bar.dart';
import '../../cache/company_cache.dart';
import '../../utils/feature_list.dart';
import '../../utils/global.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';
  final String userName;

  const HomeScreen({super.key, this.userName = ''});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeBloc>().add(SyncToServer());
    readCurrencySymbol();
    super.initState();
  }

  Future<String> readCurrencySymbol() async {
    currencySymbol = (await CompanyCache.getCurrency())!;
    return currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
        if (state is SyncingToServer) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/syncing.gif', fit: BoxFit.cover),
                    const Text(
                        'Getting things ready for you, this might take a while!',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)
                  ],
                ),
              );
            },
          );
        }
        if (state is SyncedWithServer) {
          ProgressBar.dismiss(context);
        }
        if (state is SyncingFailed) {
          ProgressBar.dismiss(context);
        }
      }, builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(spacingXXSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: spacingStandard),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UserAvatarWidget(userName: widget.userName),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SettingsScreen(),
                              LogOutWidget(),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: spacingLarge),
                      const Text(
                        "Today's Collection", // New text
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Rs. 1234.00',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(spacingMedium), // Add padding
                  child: Text(
                    'Open Tabs', // New text
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(spacingMedium),
                  child: OpenTabsWidget(),
                ),
                const SizedBox(height: spacingLarge),
                const Padding(
                  padding: EdgeInsets.all(spacingMedium),
                  child: Text(
                    'Here are some things that you can do',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(spacingSmall),
                    itemCount: features.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: DeviceUtils.isMobile(context)
                            ? 2
                            : MediaQuery.of(context).size.width ~/ 180,
                        childAspectRatio:
                            DeviceUtils.isMobile(context) ? 1.25 : 1.1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return FeatureCardWidget(
                        icon: features[index].icon,
                        label: features[index].label,
                        screen: features[index].screen,
                      );
                    })
              ],
            ),
          ),
        );
      }),
    );
  }
}
