import 'songs.dart';

class Playlist {
  List<Song> playlist;
  String name;
  int index;
  Playlist(this.playlist, this.index, this.name);
}

List<Playlist> playlists = [];