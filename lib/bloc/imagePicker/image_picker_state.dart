abstract class ImagePickerState {}

final class ImagePickerInitial extends ImagePickerState {}

final class PickingImage extends ImagePickerState {}

final class ImagePicked extends ImagePickerState {}

final class CouldNotPickImage extends ImagePickerState {
  final String errorMessage;

  CouldNotPickImage({required this.errorMessage});
}
