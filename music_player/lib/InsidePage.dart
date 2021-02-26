import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'main.dart';
import 'playlists.dart';
import 'songs.dart';
import 'accounts.dart';
import 'home.dart';
import 'favourites.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'AddSongs.dart';
import 'AccountPage.dart';
import 'PlaylistPage.dart';

class InsidePlaylist extends StatefulWidget {
  final index;
  const InsidePlaylist({Key key, this.index}) : super(key: key);
  insidePlaylist createState() => insidePlaylist(index: index);
}

class insidePlaylist extends State<InsidePlaylist> {
  AudioPlayer player;
  AudioCache cache;
  String dropdownValue = NameArtist["Believer"];
  String name = "", artist = "", file = "";
  bool isPlaying = false;
  final index;
  insidePlaylist({this.index});

  void initState() {
    super.initState();
    player = new AudioPlayer();
    cache = new AudioCache(fixedPlayer: player);
  }

  void getSongName(PLAYLIST) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 200,
              maxHeight: 300,
            ),
            child: Column(
              children: [
                Text("Add song to playlist",
                    style: TextStyle(
                      fontSize: 30,
                    )),
                Dropdown(dropdownValue),
                MaterialButton(
                  color: Colors.orangeAccent,
                  child: Text("Add"),
                  onPressed: () {
                    setState(() {
                      for (int i = 0; i < CURRENT_ACCOUNT.mySongs.length; i++) {
                        if (CURRENT_ACCOUNT.mySongs[i].title == name) {
                          artist = CURRENT_ACCOUNT.mySongs[i].artist;
                          file = CURRENT_ACCOUNT.mySongs[i].file;
                          break;
                        }
                      }
                      print("d: $dropdownValue");
                      print("n: $name");
                      var addSong = new Song(name, file, artist);
                      PLAYLIST.playlist.add(addSong);
                      Navigator.pop(context);
                      final snackBar = new SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text("Added song: $name!"));
                    });
                  },
                )
              ],
            ),
          ));
        });
  }

  Widget Dropdown(dropdownValue) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            name = dropdownValue;
            print(dropdownValue);
            print("before n: $name");
          });
        },
        items: song_names.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }

  Widget build(BuildContext context) {
    void onTap(index) {
      setState(() {
        bottom_index = index;
        if (bottom_index == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          page = AppPage.home;
        } else if (bottom_index == 1) {
          page = AppPage.add;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddSong()));
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

    var PLAYLIST = playlists[index];
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
                backgroundColor: Colors.orange[800],
                icon: Icon(
                  MdiIcons.musicNoteEighth,
                  color: Colors.black,
                ),
                activeIcon:
                    Icon(MdiIcons.musicNoteEighth, color: Colors.orange[800]),
                title: Text(
                  "My Songs",
                  //style: TextStyle(color: Colors.deepOrange),
                )),
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
                backgroundColor: Color.fromRGBO(29, 81, 252, 1),
                icon: Icon(
                  Icons.favorite,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.favorite,
                  color: Colors.yellowAccent,
                ),
                title: Text("My Saved")),
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
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
                backgroundColor: Colors.orangeAccent,
                leading: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        }),
                    SizedBox(width: 120),
                    Center(
                      child: Text(PLAYLIST.name,
                          style: TextStyle(
                            fontSize: 30,
                          )),
                    )
                  ],
                ))),
        floatingActionButton: Row(children: [
          SizedBox(width: 30),
          FloatingActionButton(
            backgroundColor: Colors.orangeAccent,
            heroTag: null,
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                print("PRESSED");
                getSongName(PLAYLIST);
              });
            },
          ),
          SizedBox(width: 275),
          FloatingActionButton(
            backgroundColor: Colors.orangeAccent,
            heroTag: null,
            child: Icon(Icons.shuffle),
            onPressed: () {
              print("SHUFFLE");
            },
          ),
        ]),
        body: PLAYLIST.playlist.length > 0
            ? ListView(shrinkWrap: true, children: [
                Container(
                  padding: EdgeInsets.only(left: 30),
                  height: 40,
                  child: Text(
                    'My Playlists',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ),
                SizedBox(height: 50),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: PLAYLIST.playlist.length,
                  itemBuilder: (context, _index) {
                    var SONG = PLAYLIST.playlist[_index];
                    return Card(
                        child: ListTile(
                      leading: IconButton(
                        icon: isPlaying
                            ? Icon(MdiIcons.pause)
                            : Icon(MdiIcons.play), // Change icon
                        onPressed: () {
                          setState(() {
                            isPlaying = !isPlaying;
                            if (!isPlaying) {
                              player.play(SONG.file);
                            } else {
                              player.pause();
                            }
                          });
                        },
                      ),
                      title: Text(SONG.title),
                      subtitle: Text(SONG.artist),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          print(SONG.title);
                          print("Fav pressed");
                        },
                      ),
                    ));
                  },
                  // return a unique playlist
                )
              ])
            : Center(
                child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 300,
                ),
                child: Text(
                    "Press the + button to add your first song in this playlist!",
                    style: TextStyle(fontSize: 40)),
              )));
  }
}
