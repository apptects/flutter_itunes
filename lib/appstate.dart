import 'package:meta/meta.dart';
import 'package:flutter_itunes/trackitem.dart';

@immutable
class AppState {
  var searchText = '';
  var trackItems = List<TrackItem>();
  var activePlayingAudioUrl = '';
  var currentAudioDuration = Duration();
}