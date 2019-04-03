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

ThunkAction<AppState> getSearchResult = (Store<AppState> store) async {
  var response = await http.get(
    Uri.encodeFull('https://itunes.apple.com/search?term=' + store.state.searchText),
  );

  Map<String, dynamic> result = jsonDecode(response.body);
  var trackItems = List<TrackItem>();

  result['results'].forEach((v) {
    if(v['wrapperType'] == 'track' && v['kind'] == 'song') {
      String collectionName = v['collectionName'] ?? '';
      String artistName = v['artistName'] ?? '';
      String trackName = v['trackName'] ?? '';
      String artwortUrl = v['artworkUrl100'] ?? '';
      String audioPreviewUrl = v['previewUrl'] ?? '';
      String trackViewUrl = v['trackViewUrl'] ?? '';

      trackItems.add(TrackItem(
          collectionName,
          artistName,
          trackName,
          artwortUrl,
          audioPreviewUrl,
          trackViewUrl));
    }
  });

  store.dispatch(UpdateTrackItemsAction(trackItems));
};