import 'package:flutter_itunes/actions.dart';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/trackitem.dart';

AppState reducer(AppState oldState, dynamic action) {
  if(action is ChangeSearchTextAction) {
    var newState = AppState();
    newState.searchText = action.searchText;
    newState.trackItems = List<TrackItem>()..addAll(oldState.trackItems);
    return newState;
  } else if (action is UpdateTrackItemsAction) {
    var newState = AppState();
    newState.searchText = oldState.searchText;
    newState.trackItems = action.trackItems;
    return newState;
  }

  return oldState;
}