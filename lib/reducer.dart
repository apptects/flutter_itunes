import 'package:flutter_itunes/actions.dart';
import 'package:flutter_itunes/appstate.dart';

AppState reducer(AppState oldState, dynamic action) {
  print('Handling action of type: $action');

  if(action is ChangeSearchTextAction) {
    return oldState.copyWith(searchText: action.searchText);
  } else if (action is UpdateTrackItemsAction) {
    return oldState.copyWith(trackItems: action.trackItems);
  } else if (action is PlayAudioUrlAction) {
    return oldState.copyWith(activePlayingAudioUrl: action.audioUrl);
  } else if (action is StopAudioAction) {
    return oldState.copyWith(activePlayingAudioUrl: '');
  } else if (action is CompletedAudioAction) {
    return oldState.copyWith(activePlayingAudioUrl: '', currentAudioDuration: Duration());
  } else if (action is AudioDurationChangedAction) {
    return oldState.copyWith(currentAudioDuration: action.duration);
  } else if (action is AlbumDetailsAction) {
    return oldState.copyWith(albumId: action.albumId);
  } else if (action is AlbumTrackItemsAction) {
    return oldState.copyWith(albumItems: action.trackItems);
  }

  return oldState;
}