import 'package:flutter_itunes/trackitem.dart';

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
