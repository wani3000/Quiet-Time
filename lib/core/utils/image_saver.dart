import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageSaver {
  /// Save image bytes to gallery
  /// Returns true if successful, false otherwise
  static Future<bool> saveToGallery(Uint8List imageBytes) async {
    try {
      if (kIsWeb) {
        // Web implementation: trigger download
        return _saveToWeb(imageBytes);
      } else {
        // Mobile implementation: save to gallery
        return _saveToMobile(imageBytes);
      }
    } catch (e) {
      // Error saving image: $e
      return false;
    }
  }

  /// Save image for web platform (trigger download) - iOS에서는 지원하지 않음
  static bool _saveToWeb(Uint8List imageBytes) {
    return false;
  }

  /// Save image for mobile platforms
  static Future<bool> _saveToMobile(Uint8List imageBytes) async {
    try {
      // Request storage permission
      final permission = await _requestPermission();
      if (!permission) {
        return false;
      }

      // Save image to gallery
      final result = await ImageGallerySaver.saveImage(
        imageBytes,
        quality: 100,
        name: 'verse_card_${DateTime.now().millisecondsSinceEpoch}',
      );

      return result['isSuccess'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Request necessary permissions for saving images
  static Future<bool> _requestPermission() async {
    if (kIsWeb) {
      // Web doesn't need permissions for downloads
      return true;
    }
    
    try {
      // For Android 13 (API 33) and above, we need different permissions
      if (await Permission.photos.isGranted) {
        return true;
      }

      // Try photos permission first (for newer Android versions)
      var status = await Permission.photos.request();
      if (status.isGranted) {
        return true;
      }

      // Fallback to storage permission for older Android versions
      status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      }

      // For iOS, check photo library add permission
      status = await Permission.photosAddOnly.request();
      return status.isGranted;
    } catch (e) {
      // Error requesting permission: $e
      return false;
    }
  }

  /// Check if we have permission to save images
  static Future<bool> hasPermission() async {
    if (kIsWeb) {
      return true;
    }
    return await Permission.photos.isGranted || 
           await Permission.storage.isGranted || 
           await Permission.photosAddOnly.isGranted;
  }
}
