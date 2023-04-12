import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'image_event.dart';

part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  int counter = 0;

  ImageBloc() : super(ImageInitial()) {
    on<RequestImagePicking>(_onRequestImagePicking);
    on<PickImage>(_onPickImage);
  }

  FutureOr<void> _onRequestImagePicking(
    RequestImagePicking event,
    Emitter<ImageState> emit,
  ) {
    if (counter == 5) {
      counter = 0;
      emit(ImageAllowed());
    }
    emit(ImageCounter(counter));
  }

  FutureOr<void> _onPickImage(
    PickImage event,
    Emitter<ImageState> emit,
  ) async {
    emit(ImageLoading());
    final image = await _pickImage(event.source);
    if (image != null) {
      emit(ImageLoaded(image));
    } else {
      emit(const ImageError('Ошибка загрузки файла'));
    }
  }


  Future<File?> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      File file = File.fromUri(Uri.parse(image.path));
      return file;
    }
    return null;
  }
}
