import 'package:flutter/material.dart';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/tracklist.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class FlutteriTunesApp extends StatelessWidget {
  final Store<AppState> _store;

  FlutteriTunesApp(this._store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: _store,
        child: MaterialApp(
            title: 'Flutter iTunes Search',
            theme: ThemeData(
                primaryColor: Colors.white,
                buttonColor: Colors.grey
            ),
            home: TrackList(title: 'iTunes Search')));
  }
}
