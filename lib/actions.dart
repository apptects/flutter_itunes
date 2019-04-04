import 'dart:convert';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/trackitem.dart';
import 'package:intl/intl.dart';
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

class AlbumTrackItemsAction {
  final DateTime albumReleaseDate;
  final List<TrackItem> trackItems;

  AlbumTrackItemsAction(this.albumReleaseDate, this.trackItems);
}

class PlayAudioUrlAction {
  final String audioUrl;

  PlayAudioUrlAction(this.audioUrl);
}

class StopAudioAction {
}

class CompletedAudioAction {
}

class AudioDurationChangedAction {
  final Duration duration;

  AudioDurationChangedAction(this.duration);
}

class AlbumDetailsAction {
  final int albumId;

  AlbumDetailsAction(this.albumId);
}

ThunkAction<AppState> getSearchResult = (Store<AppState> store) async {
  var response = await http.get(
    Uri.encodeFull('https://itunes.apple.com/search?term=' + store.state.searchText),
  );

  store.dispatch(UpdateTrackItemsAction(_decodeTrackItems(response.body)));
};

ThunkAction<AppState> getAlbumTracks = (Store<AppState> store) async {
  var response = await http.get(
    Uri.encodeFull('https://itunes.apple.com/lookup?id=${store.state.albumId}&entity=song'),
  );

  final releaseDate = _decodeAlbumReleaseDate(response.body);
  final trackItems = _decodeTrackItems(response.body);

  store.dispatch(AlbumTrackItemsAction(releaseDate, trackItems));
};

DateTime _decodeAlbumReleaseDate(String responseBody) {
  Map<String, dynamic> result = jsonDecode(responseBody);

  final resultItems = result['results'];

  for(final value in resultItems) {
    if(value['wrapperType'] == 'collection' && value['collectionType'] == 'Album') {
      return (value['releaseDate'] != null ? DateTime.parse(value['releaseDate']) : DateTime.now());
    }
  }

  return DateTime.now();
}

List<TrackItem> _decodeTrackItems(String responseBody) {
  Map<String, dynamic> result = jsonDecode(responseBody);
  var trackItems = List<TrackItem>();

  result['results'].forEach((value) {
    if(value['wrapperType'] == 'track' && value['kind'] == 'song') {

      final collectionName = value['collectionName'] ?? '';
      final collectionId = value['collectionId'];
      final artistName = value['artistName'] ?? '';
      final trackName = value['trackName'] ?? '';
      final artworkUrl = value['artworkUrl100'] ?? '';
      final audioPreviewUrl = value['previewUrl'] ?? '';
      final trackViewUrl = value['trackViewUrl'] ?? '';
      final trackDurationSeconds = (value['trackTimeMillis'] / 1000).round();

      final currencySymbol = NumberFormat().simpleCurrencySymbol(value['currency'] ?? '');
      final price = value['trackPrice'];

      final priceString = '$currencySymbol $price';

      final releaseDate = value['releaseDate'] != null ? DateTime.parse(value['releaseDate']) : DateTime.now();

      trackItems.add(
          TrackItem(
              collectionName,
              collectionId,
              artistName,
              trackName,
              artworkUrl,
              audioPreviewUrl,
              trackViewUrl,
              trackDurationSeconds,
              priceString,
              releaseDate));
    }
  });

  return trackItems;
}