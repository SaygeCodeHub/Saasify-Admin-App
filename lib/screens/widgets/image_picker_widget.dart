import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/imagePicker/image_picker_bloc.dart';
import 'package:saasify/bloc/imagePicker/image_picker_event.dart';
import 'package:saasify/bloc/imagePicker/image_picker_state.dart';
import 'package:saasify/configs/app_theme.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_spacing.dart';

typedef ImageCallBack = Function(String imagePath);

class ImagePickerWidget extends StatelessWidget {
  final String label;
  final String? initialImage;
  final ImageCallBack onImagePicked;

  const ImagePickerWidget({
    super.key,
    this.initialImage,
    required this.onImagePicked,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerBloc, ImagePickerState>(
      builder: (context, state) {
        if (state is PickingImage) {
          return const CircularProgressIndicator();
        } else if (state is ImagePicked) {
          onImagePicked(context.read<ImagePickerBloc>().imagePath);
          return Column(
            children: [
              Text(label,
                  style: Theme.of(context).textTheme.fieldLabelTextStyle),
              const SizedBox(height: spacingSmall),
              InkWell(
                onTap: () => context.read<ImagePickerBloc>().add(PickImage()),
                child: context.read<ImagePickerBloc>().imagePath.isNotEmpty
                    ? Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.transparent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.file(
                            File(context.read<ImagePickerBloc>().imagePath),
                            fit: BoxFit.cover),
                      )
                    : Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          border:
                              Border.all(color: AppColors.darkBlue, width: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            const Icon(Icons.upload, color: AppColors.darkGrey),
                      ),
              ),
            ],
          );
        } else if (state is CouldNotPickImage) {
          return Text(state.errorMessage);
        } else {
          return Column(
            children: [
              Text(label,
                  style: Theme.of(context).textTheme.fieldLabelTextStyle),
              const SizedBox(height: spacingSmall),
              InkWell(
                onTap: () => context.read<ImagePickerBloc>().add(PickImage()),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    border: Border.all(color: AppColors.darkBlue, width: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.upload, color: AppColors.darkGrey),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
