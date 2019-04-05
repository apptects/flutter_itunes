import 'package:url_launcher/url_launcher.dart';

openUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}