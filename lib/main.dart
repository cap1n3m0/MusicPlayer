import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/home.dart';
import 'SignUp.dart';
import 'songs.dart';
import 'playlists.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
String filePath = "";
String url = "https://vedantmusicplayer.000webhostapp.com";
String artistsExtension = "artists/artists.html";
String img = " ";
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  myApp createState() => myApp();
}

List<String> song_names = [];
List<String> song_links = [];
List<String> artists = [];

Map<String, String> NameLink = {};

Map<String, String> NameArtist = {};
Map<String, String> NameImage = {};

Future<String> get localPath async {
  final d = await getApplicationDocumentsDirectory();
  return d.path;
}

Future<File> get localFile async {
  final path = await localPath;
  return File('$path/$filePath');
}

// ignore: camel_case_types
class myApp extends State<MyApp> {
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Oswald'),
      title: "Music Player",
      home: HomePage(),
    );
  }
}
