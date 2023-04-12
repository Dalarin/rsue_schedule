part of 'image_bloc.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageCounter extends ImageState {
  final int counter;

  const ImageCounter(this.counter);

  @override
  List<Object> get props => [counter];
}

class ImageAllowed extends ImageState {}

class ImageLoaded extends ImageState {
  final File image;

  const ImageLoaded(this.image);

  @override
  List<Object> get props => [image];
}


class ImageError extends ImageState {
  final String message;

  const ImageError(this.message);
}
