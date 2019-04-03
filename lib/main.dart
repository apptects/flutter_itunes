import 'package:flutter/material.dart';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/flutteritunesapp.dart';
import 'package:flutter_itunes/reducer.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  runApp(FlutteriTunesApp(
      DevToolsStore<AppState>(
          reducer,
          initialState: AppState(),
          middleware: [thunkMiddleware]
      )
  ));
}
