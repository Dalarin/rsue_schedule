part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class RequestImagePicking extends ImageEvent {
  final int counter;

  const RequestImagePicking(this.counter);
}

class PickImage extends ImageEvent {
  final ImageSource source;

  const PickImage(this.source);

  @override
  List<Object> get props => [source];
}
