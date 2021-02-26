import 'package:music_player/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'files.dart';

String userAndPassFileName = "usersAndPass.txt";
enum Fav { f, n }
enum AppPage { home, account, playlist, favs, add }
AppPage page = AppPage.home;
bool muted = false;
bool song_is_playing = false;
bool show_songs = false;
int bottom_index = 0;
int playlistNumber = 0;
double volume = 0;
String path;
String scrapedSongs = " ";
String scrapedArtists = " ";
String url = "https://vedantmusicplayer.000webhostapp.com";
String artistsExtension = "artists/artists.html";
String img = " ";

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  myApp createState() => myApp();
}

// Q

List<String> song_names = [];
List<String> song_links = [];
List<String> artists = [];
Map<String, String> NameLink = {};
Map<String, String> NameArtist = {};
Map<String, String> NameImage = {};

class myApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Oswald'),
      title: "Music Player",
      home: SignUp(),
    );
  }
}
