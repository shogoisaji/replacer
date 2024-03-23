import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageSaveUseCase {
  Future<bool> saveImage(Uint8List imageBytes) async {
    final result = await ImageGallerySaver.saveImage(imageBytes);
    return result['isSuccess'];
  }
}
