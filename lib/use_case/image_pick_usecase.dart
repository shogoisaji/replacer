import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replacer/states/image_pick_state.dart';
import 'package:image/image.dart' as img;

final imagePickUseCaseProvider = Provider((ref) => ImagePickUseCase(ref: ref));

class ImagePickUseCase {
  final Ref ref;
  ImagePickUseCase({required this.ref});
  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageSize = await getImageSize(image);
      if (imageSize == null) return;
      ref.read(pickImageStateProvider.notifier).setPickImage(image, imageSize);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

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
