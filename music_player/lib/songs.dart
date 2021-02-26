import 'main.dart';

class Song {
  String title;
  String artist;
  Duration duration;
  Fav fav;
  bool play;
  bool midway;
  bool inSearchSongs;
  bool inAllSongs; 
  String file;
  Song(this.title, this.file, this.artist);
}

Song current_song;
List<Song> all_songs = [];
