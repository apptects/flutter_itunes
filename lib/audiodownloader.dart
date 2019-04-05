import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AudioDownloader {
  static final AudioDownloader _singleton = new AudioDownloader._internal();

  factory AudioDownloader() {
    return _singleton;
  }

  AudioDownloader._internal();

  Future<String> downloadUrl(String url) async {
    Uint8List rawData;

    try {
      rawData = await readBytes(url);
    } on Exception catch(e) {
      print('Failed to download $url ($e)');
      return '';
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final temporaryFile = File('${documentsDirectory.path}/${basename(url)}');

    await temporaryFile.writeAsBytes(rawData);

    return temporaryFile.path;
  }
}