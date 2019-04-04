import 'package:flutter/material.dart';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/flutteritunesapp.dart';
import 'package:flutter_itunes/reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

Store<AppState> store;

void main() {
  store = Store<AppState>(
      reducer,
      initialState: AppState.initial(),
      middleware: [thunkMiddleware]
  );

  runApp(FlutteriTunesApp(store));
}
