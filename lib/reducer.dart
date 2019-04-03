import 'package:flutter_itunes/actions.dart';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/trackitem.dart';

AppState reducer(AppState oldState, dynamic action) {
  print('Handling action of type: $action');

  if(action is ChangeSearchTextAction) {
    var newState = AppState();
    newState.searchText = action.searchText;
    newState.trackItems = List<TrackItem>()..addAll(oldState.trackItems);
    newState.activePlayingAudioUrl = oldState.activePlayingAudioUrl;
    newState.currentAudioDuration = oldState.currentAudioDuration;
    return newState;
  } else if (action is UpdateTrackItemsAction) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = action.trackItems;
    newState.activePlayingAudioUrl = oldState.activePlayingAudioUrl;
    newState.currentAudioDuration = oldState.currentAudioDuration;
    return newState;
  } else if (action is PlayAudioUrlAction) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = oldState.trackItems;
    newState.activePlayingAudioUrl = action.audioUrl;
    newState.currentAudioDuration = oldState.currentAudioDuration;
    return newState;
  } else if (action is StopAudioAction) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = oldState.trackItems;
    newState.activePlayingAudioUrl = '';
    newState.currentAudioDuration = oldState.currentAudioDuration;
    return newState;
  } else if (action is CompletedAudioAction) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = oldState.trackItems;
    newState.activePlayingAudioUrl = '';
    newState.currentAudioDuration = Duration();
    return newState;
  } else if (action is AudioDurationChanged) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = oldState.trackItems;
    newState.activePlayingAudioUrl = oldState.activePlayingAudioUrl;
    newState.currentAudioDuration = action.duration;
    return newState;
  }

  return oldState;
}