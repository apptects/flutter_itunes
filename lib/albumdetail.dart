import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/audioplayerwrapper.dart';
import 'package:flutter_itunes/helper.dart';
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(_trackItem.albumName,
                                    textScaleFactor: 2.0,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor)),
                              ),
                              IconButton(
                                icon: Icon(Icons.link),
                                color: Theme.of(context).primaryColor,
                                iconSize: 20,
                                onPressed: () => openUrl(_trackItem.trackViewUrl),
                              ),
                            ],
                          ),
                          Text('By ${_trackItem.artistName}, ${store.state.albumItems.length} Tracks (${store.state.albumReleaseDate.year})',
                            textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)
                          ),
                          Padding(padding: EdgeInsets.all(10.0)),
                          Text('Tracks',
                              textScaleFactor: 1.5,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor)),
                          Expanded(
                            child: ListView.builder(
                                itemCount: store.state.albumItems.length,
                                itemBuilder: (_, position) {
                                  var trackItem = store.state.albumItems[position];
                                  var durationHours = (trackItem.trackDurationSeconds / 60 / 60).round().toString().padLeft(2, '0');
                                  var durationMinutes = ((trackItem.trackDurationSeconds / 60).round() % 60).toString().padLeft(2, '0');
                                  var durationSeconds = (trackItem.trackDurationSeconds % 60).toString().padLeft(2, '0');
                                  var isPlaying = store.state.activePlayingAudioUrl == trackItem.audioPreviewUrl;
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 20.0,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('${position+1}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).primaryColor)),
                                          ],
                                        )
                                      ),
                                      IconButton(
                                          icon: Icon(isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline),
                                          color: Theme.of(context).primaryColor,
                                          onPressed: () {
                                            if(!isPlaying) {
                                              AudioPlayerWrapper().playTrack(trackItem.audioPreviewUrl);
                                            } else {
                                              AudioPlayerWrapper().stopTrack();
                                            }
                                          }
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(trackItem.trackName,
                                                style: TextStyle(
                                                    color: Theme.of(context).primaryColor)),
                                          ],
                                        )
                                      ),
                                      Container(
                                          width: 80,
                                          child: Column(
                                              children: [
                                                Text('$durationHours:$durationMinutes:$durationSeconds',
                                                    style: TextStyle(
                                                        color: Theme.of(context).primaryColor))
                                              ]
                                          )
                                      )
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