abstract class ImagePickerState {}

class ImagePickerInitial extends ImagePickerState {}

class PickingImage extends ImagePickerState {}

class ImagePicked extends ImagePickerState {}

class CouldNotPickImage extends ImagePickerState {
  final String errorMessage;

  CouldNotPickImage({required this.errorMessage});
}
