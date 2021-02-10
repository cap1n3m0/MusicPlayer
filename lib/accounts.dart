import 'package:flutter_application_1/playlists.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'songs.dart';

List<Account> accounts = [Account("", "", 1, "", "", "", "")];

Account CURRENT_ACCOUNT = accounts[0];

class Account {
  String username;
  String password;
  String day;
  String month;
  String year;
  String email;
  List<Song> mySongs = [];
  List<Song> recents = [];
  List<Song> favourites = [];
  List<Playlist> myPlaylists = [];
  int fetched = 0;
  int ID;
  Account(this.username, this.password, this.ID, this.day, this.month,
      this.year, this.email);

  Map<String, dynamic> toJson(String username, String password) => {
        'username': username,
        'password': password,
      };

  Account.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }
}
