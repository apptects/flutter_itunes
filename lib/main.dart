import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_itunes/actions.dart';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/audiodownloader.dart';
import 'package:flutter_itunes/reducer.dart';
import 'package:flutter_itunes/searchdialog.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(FlutteriTunesApp(
      DevToolsStore<AppState>(
          reducer,
          initialState: AppState(),
          middleware: [thunkMiddleware]
      )
  ));
}

class FlutteriTunesApp extends StatelessWidget {
  final DevToolsStore<AppState> _store;

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

class TrackList extends StatefulWidget {
  final String title;

  TrackList({Key key, this.title}) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  var _audioDownloader = AudioDownloader();
  var _audioPlayer = AudioPlayer();
  StreamSubscription<Duration> _audioDurationSubscription;
  StreamSubscription<AudioPlayerState> _audioStateSubscription;

  _TrackListState() {
    _audioDurationSubscription = _audioPlayer.onAudioPositionChanged.listen(_onAudioDurationChange);
    _audioStateSubscription = _audioPlayer.onPlayerStateChanged.listen(_onAudioPlayerStateChange);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DevToolsStore<AppState>>(
        converter: (store) => store,
        builder: (_, store) {
          return Scaffold(
              appBar: AppBar(
                  title: Text(widget.title),
                  leading: IconButton(
                    icon: Image.asset('assets/apptects.png', width: 100, height: 100),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _openUrl('https://www.apptects.de'),
                    )
              ),
              body: SafeArea(
                child: ListView.builder(
                  itemCount: store.state.trackItems.length,
                  itemBuilder: (_, position) {
                    var trackItem = store.state.trackItems[position];
                    var isPlaying = store.state.activePlayingAudioUrl == trackItem.audioPreviewUrl;
                    var currentDuration = store.state.currentAudioDuration;
                    var durationMinutes = (currentDuration.inMinutes % 60).toString().padLeft(2, '0');
                    var durationSeconds = (currentDuration.inSeconds % 60).toString().padLeft(2, '0');
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                              children: [
                                Image.network(trackItem.imageUrl)
                            ]
                          ),
                        ),
                        Container(
                          height: 120,
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  trackItem.artistName,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                trackItem.albumName,
                                overflow: TextOverflow.fade,
                                textScaleFactor: 0.8,),
                              Padding(padding: EdgeInsets.all(5.0)),
                              Text(
                                trackItem.trackName,
                                overflow: TextOverflow.ellipsis),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.link),
                                    color: Theme.of(context).buttonColor,
                                    onPressed: () => _openUrl(trackItem.trackViewUrl),
                                  ),
                                  IconButton(
                                    icon: Icon(isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline),
                                    color: Theme.of(context).buttonColor,
                                    onPressed: () {
                                      if(!isPlaying) {
                                        _playTrack(trackItem.audioPreviewUrl);
                                      } else {
                                        _stopTrack();
                                      }
                                    }
                                  ),
                                  Text(isPlaying ? '$durationMinutes:$durationSeconds' : '',
                                    textScaleFactor: 0.8, style: TextStyle(fontWeight: FontWeight.bold))
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                )
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.search),
                foregroundColor: Theme.of(context).buttonColor,
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () => _searchPressed(context),
              ),
              endDrawer: new Container(
                  width: 240.0,
                  color: Colors.white,
                  child: ReduxDevTools(store)));
        });
  }

  _searchPressed(BuildContext context) {
    showDialog(context: context, builder: (context) => SearchDialog());
  }

  _playTrack(String url) async {
    var previewFilename = await _audioDownloader.downloadUrl(url);
    print('Playing: ' + previewFilename);
    await _audioPlayer.play(previewFilename, isLocal: true);

    StoreProvider.of<AppState>(context).dispatch(PlayAudioUrlAction(url));
  }

  _stopTrack() async {
    await _audioPlayer.stop();
    StoreProvider.of<AppState>(context).dispatch(StopAudioAction());
  }

  _openUrl(String url) async {
    print('Opening url: ' + url);
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  _onAudioDurationChange(Duration duration) {
    StoreProvider.of<AppState>(context).dispatch(AudioDurationChanged(duration));
  }

  _onAudioPlayerStateChange(AudioPlayerState state) {
    if(state == AudioPlayerState.COMPLETED) {
      StoreProvider.of<AppState>(context).dispatch(CompletedAudioAction());
    }
  }
}
