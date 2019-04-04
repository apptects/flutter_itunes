class TrackItem {
  String artistName;
  String albumName;
  int albumId;
  String trackName;
  String imageUrl;
  String audioPreviewUrl;
  String trackViewUrl;
  int trackDurationSeconds;
  String price;
  DateTime releaseDate;

  TrackItem(
      this.albumName,
      this.albumId,
      this.artistName,
      this.trackName,
      this.imageUrl,
      this.audioPreviewUrl,
      this.trackViewUrl,
      this.trackDurationSeconds,
      this.price,
      this.releaseDate);
}