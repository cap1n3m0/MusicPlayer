import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'main.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'home.dart';
import 'songs.dart';
import 'accounts.dart';
import 'favourites.dart';
import 'AccountPage.dart';
import 'PlaylistPage.dart';

class AddSong extends StatefulWidget {
  addSong createState() => addSong();
}

class addSong extends State<AddSong> {
  AudioPlayer player;
  AudioCache cache;
  Duration _position = new Duration();
  var _controller = TextEditingController();
  bool _canPlay = true;
  bool canShowAll = true;
  bool isThere = false;
  bool results = true;
  bool blank = true;
  bool flag = false;
  int previewTime = 10;
  int bottom_index = 1;
  List<Song> searchSongs = [];
  List<Song> temp = [];
  String searchValue = "";

  void initState() {
    player = new AudioPlayer();
    cache = new AudioCache(fixedPlayer: player);
    flag = true;
    canShowAll = true;
    player.positionHandler = (_p) => setState(() {
          _position = _p;
        });
    super.initState();
  }

  Widget Upload(Song song) {
    if (song.play == null) {
      song.play = false;
    }
    return Card(
      child: ListTile(
        leading: IconButton(
          icon: !song.play ? Icon(MdiIcons.play) : Icon(MdiIcons.pause),
          onPressed: () {
            setState(() {
              song.play = !song.play;
              if (song.play) {
                song_is_playing = true;
                for (int i = 0; i < song_names.length; i++) {
                  if (all_songs[i] != song) {
                    all_songs[i].play = false;
                  }
                }
                player.play(song.file);
              } else {
                song_is_playing = false;
                player.pause();
              }
            });
            // play preview
          },
        ),
        title: Text(song.title),
        subtitle: Text(song.artist),
        trailing: IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
            setState(() {
              CURRENT_ACCOUNT.mySongs.add(song);
            });
          },
        ),
      ),
    );
  }

  Widget searchBar() {
    return TextField(
      controller: _controller,
      onTap: () {
        setState(() {
          canShowAll = false;
          _controller.addListener(() {});
        });
      },
      onChanged: (value) {
        flag = false;
        print(value);
        setState(() {
          searchValue = value;
        });
        setState(() {
          _canPlay = _position.inSeconds < previewTime;
          if (!_canPlay) {
            player.stop();
            _canPlay = true;
          }
          if (searchValue == "" || searchValue == null) {
            print("Cleared search songs");
            if (!flag) {
              searchSongs.clear();
            }
          }
          for (int i = 0; i < all_songs.length; i++) {
            if (all_songs[i].title.contains(searchValue)) {
              if (!searchSongs.contains(all_songs[i])) {
                print("No duplicates");
                searchSongs.add(all_songs[i]);
                searchSongs[searchSongs.length - 1].inSearchSongs = true;
              }
            } else
              searchSongs.remove(all_songs[i]);
          }
          for (int i = 0; i < all_songs.length; i++) {
            for (int j = 0; j < all_songs.length; j++) {
              if (j != i) {
                if (all_songs[i].title == all_songs[j].title) {
                  print("duplicates");
                  all_songs.removeAt(j);
                }
              }
            }
          }
          for (int i = 0; i < searchSongs.length; i++) {
            for (int j = 0; j < searchSongs.length; j++) {
              if (j != i) {
                if (searchSongs[i].title == searchSongs[j].title) {
                  print("Duplicates");
                  searchSongs.removeAt(j);
                }
              }
            }
          }
          results = searchSongs.length != 0;
        });
      },
      decoration: InputDecoration(
          hintText: "Enter a song name or artist",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
    );
  }

  Widget SearchSongs(index) {
    return Card(
      child: ListTile(
        leading: IconButton(
          color: Colors.red,
          icon: Icon(searchSongs[index].play == null
              ? MdiIcons.play
              : searchSongs[index].play == true
                  ? MdiIcons.pause
                  : MdiIcons.play),
          onPressed: () {
            setState(() {
              print("Pressed");
              if (searchSongs[index].play == null) {
                searchSongs[index].play = false;
              }
              if (searchSongs[index].play) {
                song_is_playing = false;
                searchSongs[index].play = false;
                for (int i = 0; i < song_names.length; i++) {
                  if (all_songs[i] != searchSongs[index]) {
                    all_songs[i].play = false;
                  }
                }
                player.pause();
              } else {
                song_is_playing = true;
                searchSongs[index].play = true;
                player.play(searchSongs[index].file);
              }
            });
            // play preview
          },
        ),
        title: Text(searchSongs[index].title),
        subtitle: Text(searchSongs[index].artist),
        trailing: IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
            setState(() {
              CURRENT_ACCOUNT.mySongs.add(searchSongs[index]);
            });
          },
        ),
      ),
    );
  }

  int i = 0;
  Widget build(BuildContext context) {
    setState(() {
      for (int i = 0; i < all_songs.length; i++) {
        for (int j = 0; j < all_songs.length; j++) {
          if (i != j) {
            if (all_songs[i] == all_songs[j]) {
              print("Duplicates");
              all_songs.removeAt(j);
            }
          }
        }
      }
      for (int i = 0; i < searchSongs.length; i++) {
        for (int j = 0; j < searchSongs.length; j++) {
          if (i != j) {
            if (searchSongs[i] == searchSongs[j]) {
              print("Duplicates");
              searchSongs.removeAt(j);
            }
          }
        }
      }
      if (flag) {
        for (int i = 0; i < all_songs.length; i++) {
          if (!searchSongs.contains(i)) {
            print("No duplicates");
            searchSongs.add(all_songs[i]);
            searchSongs[searchSongs.length - 1].inSearchSongs = true;
          }
        }
      } else if (searchValue == "") {
        searchSongs.clear();
      }
      blank = _controller.text.toString() == "";
      print(searchSongs.length);
      searchSongs.sort((a, b) => a.title.compareTo(b.title));
      all_songs.sort((a, b) => a.title.compareTo(b.title));
    });
    void onTap(index) {
      setState(() {
        bottom_index = index;
        if (bottom_index == 0) {
          page = AppPage.home;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          print("Home");
        } else if (bottom_index == 1) {
          page = AppPage.add;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddSong()));
          print("Add songs");
        } else if (bottom_index == 2) {
          page = AppPage.playlist;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PlaylistPage()));
        } else if (bottom_index == 3) {
          page = AppPage.favs;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => favouriteSongs()));
        } else {
          page = AppPage.account;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AccountPage()));
        }
      });
    }

    return Scaffold(
        bottomNavigationBar: BubbleBottomBar(
          backgroundColor: Color.fromARGB(255, 161, 203, 248),
          hasNotch: true,
          fabLocation: BubbleBottomBarFabLocation.end,
          opacity: .2,
          currentIndex: bottom_index,
          onTap: onTap,
          hasInk: true,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          elevation: 80,
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
                backgroundColor: Colors.blueGrey,
                icon: Icon(
                  MdiIcons.musicNoteEighth,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  MdiIcons.musicNoteEighth,
                  color: Colors.blueGrey,
                ),
                title: Text("My Songs")),
            BubbleBottomBarItem(
                backgroundColor: Colors.red,
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.add,
                  color: Colors.red,
                ),
                title: Text("Add songs")),
            BubbleBottomBarItem(
                backgroundColor: Colors.deepPurple,
                icon: Icon(
                  MdiIcons.playlistMusicOutline,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  MdiIcons.playlistMusic,
                  color: Colors.deepPurple,
                ),
                title: Text("My Playlists")),
            BubbleBottomBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(
                  Icons.favorite,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.favorite,
                  color: Colors.blue,
                ),
                title: Text("My Favourites")),
            BubbleBottomBarItem(
                backgroundColor: Colors.green,
                icon: Icon(
                  MdiIcons.account,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  MdiIcons.account,
                  color: Colors.green,
                ),
                title: Text("My Account"))
          ],
        ),
        body: Column(children: [
          SizedBox(height: 60),
          searchBar(),
          Text(
              flag
                  ? "What's trending"
                  : !results || blank
                      ? "No results"
                      : "Search results",
              style: TextStyle(
                fontSize: 60,
              )),
          SizedBox(height: 30),
          Expanded(
              child: ListView.builder(
            itemCount: flag ? all_songs.length : searchSongs.length,
            itemBuilder: (context, index) {
              return SearchSongs(index);
            },
          ))
        ]));
  }
}
