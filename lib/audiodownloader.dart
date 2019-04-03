import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AudioDownloader {
  Future<String> downloadUrl(String url) async {
    Uint8List rawData;

    try {
      rawData = await readBytes(url);
    } on ClientException {
      return '';
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final temporaryFile = File('${documentsDirectory.path}/${basename(url)}');

    await temporaryFile.writeAsBytes(rawData);

    print('Written ${temporaryFile.path}');

    return temporaryFile.path;
  }
}