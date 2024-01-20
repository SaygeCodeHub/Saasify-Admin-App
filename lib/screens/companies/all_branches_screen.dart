import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/new_app_theme.dart';
import 'package:saasify/screens/hrms/hrms_dashboard_screen.dart';
import '../../configs/spacing.dart';
import '../../utils/constants/string_constants.dart';
import '../../utils/globals.dart';
import '../../widgets/buttons/primary_button.dart';

class AllBranchesScreen extends StatefulWidget {
  final String companyName;
  static const routeName = 'AllBranchesScreen';

  const AllBranchesScreen({super.key, required this.companyName});

  @override
  State<AllBranchesScreen> createState() => _AllBranchesScreenState();
}

class _AllBranchesScreenState extends State<AllBranchesScreen> {
  int selectedIndex = 0;
  List<String> cardData = [
    "Branch 1",
    "Branch 2",
    "Branch 3",
    "Branch 4",
    "Branch 5",
    "Branch 6"
  ];

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < mobileBreakPoint;
    return PopScope(
        canPop: false,
        child: Scaffold(
            body: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(spacingBetweenTextFieldAndButton),
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.80,
              width: MediaQuery.sizeOf(context).width * 0.60,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey, width: 5.0)),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.18,
                    child: SizedBox(
                        height: MediaQuery.sizeOf(context).height,
                        child: Image.asset('assets/abstract.png',
                            fit: BoxFit.fill)),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(
                          spacingBetweenTextFieldAndButton),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Company 1',
                              style: Theme.of(context)
                                  .textTheme
                                  .headingTextStyle
                                  .copyWith(color: AppColors.black)),
                          const SizedBox(height: spacingMedium),
                          const Text('Select a branch'),
                          const SizedBox(height: spacingMedium),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.30,
                            child: Scrollbar(
                              child: GridView.builder(
                                itemCount: cardData
                                    .length, // Number of items in your grid
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 8.0,
                                        mainAxisSpacing: 8.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                    child: Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: selectedIndex == index
                                                    ? AppColors.orange
                                                    : Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.all(spacingXXSmall),
                                              child: Icon(Icons.store),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                  spacingXMedium),
                                              child: Text(cardData[index]),
                                            )
                                          ],
                                        )),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                              height: spacingBetweenTextFieldAndButton),
                          PrimaryButton(
                              buttonTitle: StringConstants.kNext,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, HRMSDashboardScreen.routeName);
                              })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
