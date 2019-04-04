import 'package:flutter_itunes/actions.dart';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/trackitem.dart';

AppState reducer(AppState oldState, dynamic action) {
  print('Handling action of type: $action');

  if(action is ChangeSearchTextAction) {
    var newState = AppState();
    newState.searchText = action.searchText;
    newState.trackItems = List<TrackItem>()..addAll(oldState.trackItems);
    newState.albumId = oldState.albumId;
    newState.activePlayingAudioUrl = oldState.activePlayingAudioUrl;
    newState.currentAudioDuration = oldState.currentAudioDuration;
    newState.albumItems = oldState.albumItems;
    return newState;
  } else if (action is UpdateTrackItemsAction) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = action.trackItems;
    newState.activePlayingAudioUrl = oldState.activePlayingAudioUrl;
    newState.currentAudioDuration = oldState.currentAudioDuration;
    newState.albumId = oldState.albumId;
    newState.albumItems = oldState.albumItems;
    return newState;
  } else if (action is PlayAudioUrlAction) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = oldState.trackItems;
    newState.activePlayingAudioUrl = action.audioUrl;
    newState.currentAudioDuration = oldState.currentAudioDuration;
    newState.albumId = oldState.albumId;
    newState.albumItems = oldState.albumItems;
    return newState;
  } else if (action is StopAudioAction) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = oldState.trackItems;
    newState.activePlayingAudioUrl = '';
    newState.currentAudioDuration = oldState.currentAudioDuration;
    newState.albumId = oldState.albumId;
    newState.albumItems = oldState.albumItems;
    return newState;
  } else if (action is CompletedAudioAction) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = oldState.trackItems;
    newState.activePlayingAudioUrl = '';
    newState.currentAudioDuration = Duration();
    newState.albumId = oldState.albumId;
    newState.albumItems = oldState.albumItems;
    return newState;
  } else if (action is AudioDurationChangedAction) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = oldState.trackItems;
    newState.activePlayingAudioUrl = oldState.activePlayingAudioUrl;
    newState.currentAudioDuration = action.duration;
    newState.albumId = oldState.albumId;
    newState.albumItems = oldState.albumItems;
    return newState;
  } else if (action is AlbumDetailsAction) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = oldState.trackItems;
    newState.activePlayingAudioUrl = oldState.activePlayingAudioUrl;
    newState.currentAudioDuration = oldState.currentAudioDuration;
    newState.albumId = action.albumId;
    newState.albumItems = oldState.albumItems;
    return newState;
  } else if (action is AlbumTrackItemsAction) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = oldState.trackItems;
    newState.activePlayingAudioUrl = oldState.activePlayingAudioUrl;
    newState.currentAudioDuration = oldState.currentAudioDuration;
    newState.albumId = oldState.albumId;
    newState.albumItems = action.trackItems;
    return newState;
  }

  return oldState;
}