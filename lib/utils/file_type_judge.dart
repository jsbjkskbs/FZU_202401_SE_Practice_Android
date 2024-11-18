import 'dart:io';

import 'package:mime/mime.dart';

class FileTypeJudge {
  static bool isVideo(File file) {
    var result = lookupMimeType(
      file.path,
      headerBytes: file.readAsBytesSync(),
    );
    return result != null && result.startsWith('video');
  }

  static bool isImage(File file) {
    var result = lookupMimeType(
      file.path,
      headerBytes: file.readAsBytesSync(),
    );
    return result != null && result.startsWith('image');
  }
}
