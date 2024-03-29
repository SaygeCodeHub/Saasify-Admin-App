import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/screens/home/widgets/feature_card_widget.dart';
import 'package:saasify/screens/home/widgets/logout_widget.dart';
import 'package:saasify/screens/home/widgets/open_tabs_widget.dart';
import 'package:saasify/screens/home/widgets/settings_widget.dart';
import 'package:saasify/screens/home/widgets/user_avatar_widget.dart';
import '../../utils/feature_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(spacingXXSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UserAvatarWidget(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SettingsScreen(),
                            LogOutWidget(),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: spacingLarge),
                    Text(
                      "Today's Collection", // New text
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
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
                padding: EdgeInsets.all(spacingMedium), // Add padding
                child: OpenTabsWidget(),
              ),
              const SizedBox(height: spacingLarge),
              const Padding(
                padding: EdgeInsets.all(spacingMedium), // Add padding
                child: Text(
                  'Here are some things that you can do', // New text
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(spacingSmall),
                itemCount: features.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return FeatureCardWidget(
                    icon: features[index].icon,
                    label: features[index].label,
                    screen: features[index].screen,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
