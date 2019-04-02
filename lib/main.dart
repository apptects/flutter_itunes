import 'package:flutter/material.dart';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/reducer.dart';
import 'package:flutter_itunes/searchdialog.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

void main() {
  runApp(FlutteriTunesApp(
      DevToolsStore<AppState>(reducer, initialState: AppState())));
}

class FlutteriTunesApp extends StatelessWidget {
  final DevToolsStore<AppState> _store;

  FlutteriTunesApp(this._store);

  @override
  Widget build(BuildContext context) {
    print(_store);
    return StoreProvider<AppState>(
        store: _store,
        child: MaterialApp(
            title: 'Flutter iTunes Search',
            home: TrackList(title: 'iTunes Search')));
  }
}

class TrackList extends StatefulWidget {
  final String title;

  TrackList({Key key, this.title}) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DevToolsStore<AppState>>(
      converter: (store) => store,
      builder: (_, store) {
        return Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: ListView(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () => _searchPressed(context),
          ),
          endDrawer: new Container(
            width: 240.0,
            color: Colors.white,
            child: ReduxDevTools(store))
        );
      }
    );
  }
}

_searchPressed(BuildContext context) {
  showDialog(context: context, builder: (context) => SearchDialog());
}