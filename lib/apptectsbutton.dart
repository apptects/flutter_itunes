import 'package:flutter/material.dart';
import 'package:flutter_itunes/helper.dart';

class ApptectsButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/apptects.png', width: 100, height: 100),
      color: Theme.of(context).primaryColor,
      onPressed: () => openUrl('https://www.apptects.de'),
    );
  }
}