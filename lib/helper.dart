import 'package:url_launcher/url_launcher.dart';

openUrl(String url) async {
  print('Opening url: ' + url);
  if (await canLaunch(url)) {
    await launch(url);
  }
}