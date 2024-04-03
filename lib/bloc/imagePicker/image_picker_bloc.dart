import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saasify/bloc/imagePicker/image_picker_event.dart';
import 'package:saasify/bloc/imagePicker/image_picker_state.dart';
import 'package:saasify/utils/image_handling.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerState get initialState => ImagePickerInitial();

  ImagePickerBloc() : super(ImagePickerInitial()) {
    on<PickImage>(_pickImage);
  }

  String imagePath = '';

  FutureOr<void> _pickImage(
      PickImage event, Emitter<ImagePickerState> emit) async {
    try {
      final XFile? pickedImageFile = await ImageUtil.pickImage();
      emit(PickingImage());
      if (kIsWeb) {
        imagePath = pickedImageFile!.path;
        emit(ImagePicked());
      } else {
        if (pickedImageFile != null) {
          imagePath = pickedImageFile.path;
          emit(ImagePicked());
        } else {
          emit(CouldNotPickImage(
              errorMessage: 'Could not pick image. Please try again!'));
        }
      }
    } catch (e) {
      emit(CouldNotPickImage(
          errorMessage: 'Could not pick image: ${e.toString()}'));
    }
  }
}
