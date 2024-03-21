import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replacer/states/image_pick_state.dart';
import 'package:image/image.dart' as img;
import 'package:replacer/utils/image_converter.dart';

final imagePickUseCaseProvider = Provider((ref) => ImagePickUseCase(ref: ref));

class ImagePickUseCase {
  final Ref ref;
  ImagePickUseCase({required this.ref});

  Future<void> pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final ui.Image? convertedImage = await ImageConverter().convertXFileToImage(image);
      if (convertedImage == null) return;
      // final imageSize = await getImageSize(image);
      // if (imageSize == null) return;
      ref.read(pickImageStateProvider.notifier).setPickImage(convertedImage);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  /// ui.Imageから画像サイズが取れるので今回は使わないかも
  Future<Size?> getImageSize(XFile file) async {
    Uint8List? imageData = await file.readAsBytes();
    img.Image? image = img.decodeImage(imageData);
    if (image != null) {
      int width = image.width;
      int height = image.height;
      print('画像のサイズ: 幅 $width x 高さ $height');
      return Size(width.toDouble(), height.toDouble());
    } else {
      print('画像をデコードできませんでした。');
    }
    return null;
  }
}
