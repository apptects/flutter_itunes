import 'dart:convert';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/trackitem.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class ChangeSearchTextAction {
  final String searchText;

  ChangeSearchTextAction(this.searchText);
}

class UpdateTrackItemsAction {
  final List<TrackItem> trackItems;

  UpdateTrackItemsAction(this.trackItems);
}

class PlayAudioUrlAction {
  final String audioUrl;

  PlayAudioUrlAction(this.audioUrl);
}

class StopAudioAction {
}

class CompletedAudioAction {
}

class AudioDurationChanged {
  final Duration duration;

  AudioDurationChanged(this.duration);
}

ThunkAction<AppState> getSearchResult = (Store<AppState> store) async {
  var response = await http.get(
    Uri.encodeFull('https://itunes.apple.com/search?term=' + store.state.searchText),
  );

  Map<String, dynamic> result = jsonDecode(response.body);
  var trackItems = List<TrackItem>();

  result['results'].forEach((v) {
    if(v['wrapperType'] == 'track' && v['kind'] == 'song') {
      final collectionName = v['collectionName'] ?? '';
      final artistName = v['artistName'] ?? '';
      final trackName = v['trackName'] ?? '';
      final artworkUrl = v['artworkUrl100'] ?? '';
      final audioPreviewUrl = v['previewUrl'] ?? '';
      final trackViewUrl = v['trackViewUrl'] ?? '';
      final trackDurationSeconds = v['trackTimeMillis'];

      trackItems.add(TrackItem(
          collectionName,
          artistName,
          trackName,
          artworkUrl,
          audioPreviewUrl,
          trackViewUrl,
          trackDurationSeconds));
    }
  });

  store.dispatch(UpdateTrackItemsAction(trackItems));
};