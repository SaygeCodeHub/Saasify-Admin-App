import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/pos/pos_bloc.dart';
import 'package:saasify/bloc/pos/pos_event.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/models/pos_model.dart';

class AddToCartSection extends StatelessWidget {
  final List<PosModel> posDataList;

  const AddToCartSection({super.key, required this.posDataList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          shrinkWrap: true,
          itemCount: posDataList.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: spacingXXSmall),
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.all(spacingSmall),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox.square(
                        dimension: kCartNetworkImageSizedBoxDimension,
                        child: CachedNetworkImage(
                            imageUrl: posDataList[index].image,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            width: kCartNetworkImageTogether,
                            height: kCartNetworkImageTogether,
                            fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: spacingSmall),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${posDataList[index].name} ${posDataList[index].quantity.toString()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .productNameTextStyle),
                            Text(posDataList[index].description,
                                style: Theme.of(context)
                                    .textTheme
                                    .variantNameTextStyle),
                            const SizedBox(height: spacingXSmall),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: kCartCountContainerWidth,
                                        height: kCartCountContainerHeight,
                                        decoration: BoxDecoration(
                                            color: AppColors.lighterGrey,
                                            border: Border.all(
                                                color: AppColors.grey),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                            child: Text(posDataList[index]
                                                .count
                                                .toString())),
                                      ),
                                      Positioned(
                                        left: -0.3,
                                        child: InkWell(
                                          onTap: () {
                                            context.read<PosBloc>().add(
                                                DecrementVariantCount(
                                                    posDataList: posDataList,
                                                    selectedVariantIndex:
                                                        index));
                                          },
                                          child: Container(
                                            height: kCartCountTogether,
                                            width: kCartCountTogether,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.lighterGrey
                                                        .withOpacity(0.2),
                                                    offset:
                                                        const Offset(4.0, 4.0),
                                                    blurRadius: 2.0,
                                                    spreadRadius: 1.0,
                                                  )
                                                ],
                                                color: AppColors.white,
                                                border: Border.all(
                                                    color: AppColors.darkGrey),
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: const Icon(Icons.remove,
                                                size:
                                                    kCartRemoveAndAddIconSize),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 52,
                                        child: InkWell(
                                          onTap: () {
                                            context.read<PosBloc>().add(
                                                IncrementVariantCount(
                                                    posDataList: posDataList,
                                                    selectedVariantIndex:
                                                        index));
                                          },
                                          child: Container(
                                            height: kCartCountTogether,
                                            width: kCartCountTogether,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.lighterGrey
                                                        .withOpacity(0.2),
                                                    offset:
                                                        const Offset(4.0, 4.0),
                                                    blurRadius: 5.0,
                                                    spreadRadius: 1.0,
                                                  )
                                                ],
                                                color: AppColors.white,
                                                border: Border.all(
                                                    color: AppColors.darkGrey),
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: const Icon(Icons.add,
                                                size: kCartRemoveAndAddIconSize,
                                                color: AppColors.blue),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          text: '₹ ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .descriptionTextStyle,
                                          children: <TextSpan>[
                                        TextSpan(
                                            text: posDataList[index]
                                                .cost
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .productCostTextStyle)
                                      ]))
                                ])
                          ]),
                    ),
                  ],
                ));
          }),
    );
  }
}
