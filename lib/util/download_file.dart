import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

enum DownloadFileType {
  image,
  audio,
  video,
}

class JackDownload {
  static Future<String> downloadFile({
    required String url,
    required DownloadFileType type,
    String? savePath,
  }) async {
    // Generate a v4 (crypto-random) id
    var v4Crypto = const Uuid()
        .v4(options: {'rng': UuidUtil.cryptoRNG})
        .split('-')
        .join("");
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        "${directory.path}/${savePath ?? v4Crypto}${type.name == "image" ? ".png" : type.name == "video" ? ".mp4" : type.name == "audio" ? ".aac" : ""}";
    await Dio().download(url, filePath);
    return filePath;
  }
}
