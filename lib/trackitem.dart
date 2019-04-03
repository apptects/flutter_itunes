class TrackItem {
  String artistName;
  String albumName;
  String trackName;
  String imageUrl;
  String audioPreviewUrl;
  String trackViewUrl;
  int trackDurationSeconds;

  TrackItem(
      this.albumName,
      this.artistName,
      this.trackName,
      this.imageUrl,
      this.audioPreviewUrl,
      this.trackViewUrl,
      this.trackDurationSeconds);
}