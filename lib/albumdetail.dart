import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_itunes/actions.dart';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_itunes/audioplayerwrapper.dart';
import 'package:flutter_itunes/helper.dart';
import 'package:flutter_itunes/main.dart';
import 'package:flutter_itunes/rest.dart';
import 'package:flutter_itunes/trackitem.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path/path.dart';
import 'package:redux/redux.dart';

class AlbumDetail extends StatelessWidget {
  TrackItem _trackItem;
  String _backgroundImageUrl;

  AlbumDetail(TrackItem trackItem) {
    _trackItem = trackItem;
    _backgroundImageUrl = dirname(_trackItem.imageUrl) + '/1000x1000-999' + extension(_trackItem.imageUrl);

    store.dispatch(AlbumDetailsAction(_trackItem.albumId));
    store.dispatch(getAlbumTracks);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (_, store) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_trackItem.albumName)
          ),
          body: _AlbumDetailBackground(_backgroundImageUrl, _trackItem)
          );
        });
    }
}

class _AlbumDetailBackground extends StatelessWidget {
  final String _backgroundImageUrl;
  final TrackItem _trackItem;

  _AlbumDetailBackground(this._backgroundImageUrl, this._trackItem);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(_backgroundImageUrl),
                fit: BoxFit.cover)),
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey,
                      Colors.black
                    ]
                ),
                backgroundBlendMode: BlendMode.darken),
            child: _AlbumDetailItems(_trackItem)
        )
    );
  }
}

class _AlbumDetailItems extends StatelessWidget {
  final TrackItem _selectedTrackItem;

  _AlbumDetailItems(this._selectedTrackItem);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (_, store) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _AlbumDetailName(_selectedTrackItem.albumName),
                    _AlbumDetailOpenUrlButton(_selectedTrackItem.trackViewUrl),
                  ],
                ),
                _AlbumDetailArtistTracksReleaseDate(_selectedTrackItem.artistName, store.state.albumItems.length, store.state.albumReleaseDate.year),
                Padding(padding: EdgeInsets.all(10.0)),
                _AlbumTrackListHeader(),
                _TrackList(store.state.albumItems, store.state.activePlayingAudioUrl)
              ],
            ),
          );
        });
  }
}

class _AlbumDetailArtistTracksReleaseDate extends StatelessWidget {
  final String _artistName;
  final int _numTracks;
  final int _releaseDateYear;

  _AlbumDetailArtistTracksReleaseDate(this._artistName, this._numTracks, this._releaseDateYear);

  @override
  Widget build(BuildContext context) {
    return Text('By $_artistName, $_numTracks Tracks ($_releaseDateYear)',
        textScaleFactor: 1.0,
        style: TextStyle(
            color: Theme
                .of(context)
                .primaryColor)
    );
  }
}

class _AlbumTrackListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Tracks',
        textScaleFactor: 1.5,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme
                .of(context)
                .primaryColor));
  }
}

class _AlbumDetailName extends StatelessWidget {
  final String _albumName;

  _AlbumDetailName(this._albumName);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(_albumName,
          textScaleFactor: 2.0,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme
                  .of(context)
                  .primaryColor)),
    );
  }
}

class _AlbumDetailOpenUrlButton extends StatelessWidget {
  final String _albumUrl;

  _AlbumDetailOpenUrlButton(this._albumUrl);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.link),
      color: Theme
          .of(context)
          .primaryColor,
      iconSize: 20,
      onPressed: () => openUrl(_albumUrl),
    );
  }
}

class _TrackList extends StatelessWidget {
  final List<TrackItem> _trackItems;
  final String _activePlayingAudioUrl;

  _TrackList(this._trackItems, this._activePlayingAudioUrl);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SafeArea(
          child: ListView.builder(
              itemCount: _trackItems.length,
              itemBuilder: (_, position) {
                var trackItem = _trackItems[position];
                var isPlaying = _activePlayingAudioUrl == trackItem.audioPreviewUrl;
                return _TrackListRow(position, trackItem, isPlaying);
              })
          )
      );
    }
}

class _TrackListRow extends StatelessWidget {
  final int _position;
  final TrackItem _trackItem;
  final bool _isPlaying;

  _TrackListRow(this._position, this._trackItem, this._isPlaying);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _TrackItemPosition(_position),
        _TrackItemPlayPauseButton(_isPlaying, _trackItem.audioPreviewUrl),
        _TrackItemName(_trackItem.trackName),
        _TrackItemDuration(_trackItem.trackDurationSeconds)
      ],
    );
  }
}

class _TrackItemPosition extends StatelessWidget {
  final int _position;

  _TrackItemPosition(this._position);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 30,
        height: 20.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${_position+1}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
          ],
        )
    );
  }
}

class _TrackItemPlayPauseButton extends StatelessWidget {
  final bool _isPlaying;
  final String _audioPreviewUrl;

  _TrackItemPlayPauseButton(this._isPlaying, this._audioPreviewUrl);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(_isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          if(!_isPlaying) {
            AudioPlayerWrapper().playTrack(_audioPreviewUrl);
          } else {
            AudioPlayerWrapper().stopTrack();
          }
        }
    );
  }
}

class _TrackItemName extends StatelessWidget {
  final String _trackName;

  _TrackItemName(this._trackName);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_trackName,
                style: TextStyle(
                    color: Theme.of(context).primaryColor)),
          ],
        )
    );
  }
}

class _TrackItemDuration extends StatelessWidget {
  final int _trackDurationSeconds;

  _TrackItemDuration(this._trackDurationSeconds);

  @override
  Widget build(BuildContext context) {
    var durationHours = (_trackDurationSeconds / 60 / 60).round().toString().padLeft(2, '0');
    var durationMinutes = ((_trackDurationSeconds / 60).round() % 60).toString().padLeft(2, '0');
    var durationSeconds = (_trackDurationSeconds % 60).toString().padLeft(2, '0');

    return Container(
        width: 80,
        child: Column(
            children: [
              Text('$durationHours:$durationMinutes:$durationSeconds',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor))
            ]
        )
    );
  }
}