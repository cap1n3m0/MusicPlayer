import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/home.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'main.dart';
import 'songs.dart';
import 'accounts.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:audioplayers/audio_cache.dart';
import 'AccountPage.dart';
import 'AddSongs.dart';
import 'PlaylistPage.dart';

class favouriteSongs extends StatefulWidget {
  _favouriteSongs createState() => _favouriteSongs();
}

class _favouriteSongs extends State<favouriteSongs> {
  Duration dur = new Duration();
  Duration pos = new Duration();
  AudioCache cache;
  AudioPlayer player;
  Duration _position = new Duration();
  Duration _duration = new Duration();

  void initState() {
    super.initState();
    player = new AudioPlayer();
    cache = new AudioCache(fixedPlayer: player);
    bottom_index = 3;
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

    return Scaffold(
      body: CURRENT_ACCOUNT.favourites.length > 0
          ? ListView.builder(
              itemCount: CURRENT_ACCOUNT.favourites.length,
              itemBuilder: (context, index) {
                return CURRENT_ACCOUNT.favourites.length > 0
                    ? favourite(context, index)
                    : null;
              })
          : Center(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 320,
                  ),
                  child: Text(
                      "No favourites yet! Press the heart button beside one of your songs to add it to your favourite list!",
                      style: TextStyle(
                        fontSize: 50,
                      )))),
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
    );
  }

  Widget favourite(context, index) {
    var FAV_SONG = CURRENT_ACCOUNT.favourites[index];

    void seekToSecond(var value) {
      Duration newTime = new Duration(seconds: value.toInt());
      player.seek(newTime);
      value = value;
    }

    void play_song() {
      player.play(all_songs[index].file);
      _position = pos;
      seekToSecond(pos.inSeconds);
    }

    void resume() async {
      await player.resume();
    }

    void releaseMode(release) async {
      await player.setReleaseMode(release);
    }

    void release() async {
      await player.release();
    }

    releaseMode(ReleaseMode.RELEASE);
    if (FAV_SONG.play == null) {
      FAV_SONG.play = false;
    }
    return Card(
        child: ListTile(
            leading: IconButton(
                icon: Icon(
                  FAV_SONG.play ? MdiIcons.pause : MdiIcons.play,
                ),
                onPressed: () {
                  setState(() {
                    FAV_SONG.play = !FAV_SONG.play;
                    for (int l = 0;
                        l < CURRENT_ACCOUNT.favourites.length;
                        l++) {
                      if (l != index) {
                        FAV_SONG.play = false;
                      }
                    }
                    if (FAV_SONG.play) {
                      song_is_playing = true;
                      if (pos.inSeconds != null) {
                        if (pos.inSeconds < 1.0) {
                          play_song();
                        } else {
                          resume();
                        }
                      }
                    } else {
                      pos = _position;
                      song_is_playing = false;
                      player.pause();
                      release();
                    }
                  });
                }),
            title: Text(FAV_SONG.title),
            subtitle: Text(FAV_SONG.artist),
            trailing: IconButton(
                icon: Icon(Icons.favorite),
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < CURRENT_ACCOUNT.mySongs.length; i++) {
                      if (CURRENT_ACCOUNT.mySongs[i] == FAV_SONG) {
                        CURRENT_ACCOUNT.mySongs[i].fav = Fav.n;
                      }
                    }
                    CURRENT_ACCOUNT.favourites.remove(FAV_SONG);
                  });
                })));
  }
}
