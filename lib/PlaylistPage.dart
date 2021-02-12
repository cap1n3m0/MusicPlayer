import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/favourites.dart';
import 'AddSongs.dart';
import 'SignIn.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'main.dart';
import 'songs.dart';
import 'playlists.dart';
import 'AccountPage.dart';
import 'home.dart';
import 'InsidePage.dart';

class PlaylistPage extends StatefulWidget {
  playlistPage createState() => playlistPage();
}

class playlistPage extends State<PlaylistPage> {
  void initState() {
    super.initState();
    bottom_index = 2;
  }

  Widget PlaylistW(int index) {
    var PLAYLIST = playlists[index];
    return GestureDetector(
      child: Card(
          child: ListTile(
        title: Text(PLAYLIST.name),
      )),
      onTap: () {
        print("Tapped");
        try {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InsidePlaylist(index: index)));
        } catch (e) {
          print("FATAL: $e");
        }
      },
    );
  }

  Future<void> makeNewPlaylist() {
    String name, file, artist;
    if (name == null) {
      name = "example song";
    }
    if (file == null) {
      file = "example.mp3";
    }
    if (artist == null) {
      artist = "example artist";
    }
    TextEditingController playlistTitle = new TextEditingController();
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Make new playlist"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: playlistTitle,
                    ),
                    MaterialButton(
                      color: Colors.yellow,
                      child: Text("Save"),
                      onPressed: () {
                        setState(() {
                          playlistNumber++;
                          List<Song> newSongs = [];
                          Playlist newList = new Playlist(newSongs,
                              playlistNumber, playlistTitle.text.toString());
                          playlists.add(newList);
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ),
              ));
        });
  }

  Widget build(BuildContext context) {
    void onTap(index) {
      setState(() {
        bottom_index = index;
        if (bottom_index == 0) {
          page = AppPage.home;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
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

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              makeNewPlaylist();
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          fabLocation: BubbleBottomBarFabLocation.end,
          backgroundColor: Color.fromARGB(255, 161, 203, 248),
          hasNotch: true,
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
                  MdiIcons.account,
                  color: Colors.red,
                ),
                title: Text("My Account")),
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
        body: playlists.length > 0
            ? ListView(children: [
                Container(
                  padding: EdgeInsets.only(left: 30),
                  height: 60,
                  child: Text(
                    "My Playlists",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    return PlaylistW(index);
                  },
                )
              ])
            : Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 320,
                    ),
                    child: Text(
                        "No playlists yet! Press the button to make a new playlist!",
                        style: TextStyle(
                          fontSize: 50,
                        )))));
  }
}
