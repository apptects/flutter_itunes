import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/trackitem.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path/path.dart';
import 'package:redux/redux.dart';

class AlbumDetail extends StatelessWidget {
  TrackItem _trackItem;
  String _highResAlbumArtworkUrl;

  AlbumDetail(TrackItem trackItem) {
    this._trackItem = trackItem;
    this._highResAlbumArtworkUrl = dirname(_trackItem.imageUrl) + '/9000x9000-999' + extension(_trackItem.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (_, store) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_trackItem.albumName),
          ),
          body: Container(
               decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(_highResAlbumArtworkUrl), fit: BoxFit.cover)),
               child: Container(
                   decoration: BoxDecoration(
                     gradient: LinearGradient(
                       begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                       colors: [
                         Colors.grey,
                         Colors.black
                       ]
                     ),
                     backgroundBlendMode: BlendMode.darken,),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(_trackItem.albumName,
                            textScaleFactor: 2.0,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                          Text('By ' + _trackItem.artistName,
                            textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: store.state.albumItems.length,
                                itemBuilder: (_, position) {
                                  //final trackItem = store.state
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('1')
                                    ],
                                  );
                                }),
                          )
                        ],
                      ),
                    )
                   )
               ),
          );
        });
    }
}