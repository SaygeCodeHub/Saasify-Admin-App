import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/pos/pos_bloc.dart';
import 'package:saasify/bloc/pos/pos_event.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/models/pos_model.dart';

class ClearCartLabel extends StatelessWidget {
  final List<PosModel> posDataList;
  const ClearCartLabel({super.key, required this.posDataList});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title:
                        const Text("Are you sure you want to clear the cart?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            context
                                .read<PosBloc>()
                                .add(ClearCart(posDataList: posDataList));
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'))
                    ],
                  );
                });
          },
          child: Text('Clear Cart',
              style: Theme.of(context)
                  .textTheme
                  .errorSubtitleTextStyle
                  .copyWith(color: AppColors.blue))),
    );
  }
}
