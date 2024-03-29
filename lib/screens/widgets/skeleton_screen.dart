import 'package:flutter/material.dart';
import 'package:saasify/configs/app_theme.dart';
import '../../configs/app_spacing.dart';
import '../../utils/global.dart';

class SkeletonScreen extends StatelessWidget {
  final String appBarTitle;
  final List<Widget> bottomBarButtons;
  final Widget bodyContent;

  const SkeletonScreen({
    super.key,
    required this.appBarTitle,
    required this.bottomBarButtons,
    required this.bodyContent,
  });

  @override
  Widget build(BuildContext context) {
    final double padding = isMobile ? newMobileBodyPadding : newWebBodyPadding;

    return Scaffold(
        appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.only(left: isMobile ? 0.00 : spacingLarge),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            title: Text(appBarTitle,
                style: Theme.of(context).textTheme.appBarTitle)),
        body: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: bodyContent),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Padding(
          padding: const EdgeInsets.all(spacingSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: bottomBarButtons.map((button) {
              return SizedBox(
                width: isMobile ? MediaQuery.sizeOf(context).width * 0.94 : 150,
                child: bottomBarButtons[0],
              );
            }).toList(),
          ),
        )));
  }
}
