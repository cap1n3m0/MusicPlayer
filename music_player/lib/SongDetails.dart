import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'dart:math';
import 'Favourites.dart';
import 'PlaylistPage.dart';
import 'AddSongs.dart';
import 'home.dart';
import 'main.dart';
import 'accounts.dart';
import 'songs.dart';
import 'AccountPage.dart';

class SongDetails extends StatefulWidget {
  final AudioPlayer player;
  final AudioCache cache;
  final play;
  final index;
  const SongDetails({Key key, this.player, this.cache, this.play, this.index})
      : super(key: key);
  songDetails createState() =>
      songDetails(play: play, index: index, player: player, cache: cache);
}

class songDetails extends State<SongDetails> {
  Duration _position = new Duration();
  Duration _duration = new Duration();
  double volume = 10.0;
  Duration pos;
  bool isDisposed = false;
  final index;
  final play;
  AudioPlayer player;
  final cache;
  songDetails({this.play, this.index, this.player, this.cache});

  void seekToSecond(var value) async {
    player.seek(new Duration(seconds: value.toInt()));
    value = value;
  }

  void playSong() {
    player.play(CURRENT_ACCOUNT.mySongs[index].file);
    _position = pos;
    seekToSecond(pos.inSeconds);
    print("p: ${_position.inSeconds}");
  }

  void resume() async {
    await player.resume();
  }

  void releaseMode(release) async {
    await player.setReleaseMode(release);
  }

  void dispose() {
    player.dispose();
    super.dispose();
  }

  void getDurationAndPosition() {
    player.durationHandler = (_d) => setState(() {
          _duration = _d;
        });
    player.positionHandler = (_p) => setState(() {
          _position = _p;
        });
  }

  void initState() {
    super.initState();
    player = new AudioPlayer();
    releaseMode(ReleaseMode.RELEASE); // default release
    pos = new Duration();
    isDisposed = false;
    getDurationAndPosition();
  }

  @override
  Widget build(BuildContext context) {
    void onTap(index) {
      setState(() {
        // release(); // remove
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
      dispose();
    }

    player.onDurationChanged.listen((Duration _dur) {
      if (this.mounted) {
        setState(() {
          current_song.duration = _dur;
        });
      }
      player.onAudioPositionChanged.listen((Duration _pos) {
        if (this.mounted) {
          setState(() {
            _position = _pos;
          });
        }
      });
    });
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
      appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          leading: new Container(
              child: IconButton(
                  icon: Icon(MdiIcons.arrowLeft),
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        CURRENT_ACCOUNT.mySongs[index].play = false;
                        player.stop();
                        Navigator.pop(context);
                      });
                      _position = new Duration();
                      _duration = new Duration();
                      if (this.mounted) {
                        getDurationAndPosition();
                      }
                    }
                    dispose();
                  }))),
      body: Column(children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.red[700],
            inactiveTrackColor: Colors.red[100],
            trackShape: RoundedRectSliderTrackShape(),
            trackHeight: 4.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
            thumbColor: Colors.redAccent,
            overlayColor: Colors.red.withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            tickMarkShape: RoundSliderTickMarkShape(),
            activeTickMarkColor: Colors.red[700],
            inactiveTickMarkColor: Colors.red[100],
            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.redAccent,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          child: Slider(
            value: _position.inSeconds.toDouble() == null
                ? 1.0
                : _position.inSeconds.toDouble(),
            min: 0.0,
            max: _duration.inSeconds.toDouble() == null
                ? 100.0
                : _duration.inSeconds.toDouble(),
            label: _position.inSeconds.toString(),
            onChanged: (value) {
              print("changed: $value");
              try {
                seekToSecond(value);
              } catch (e) {
                print("FATAL ERROR: $e");
              }
            },
          ),
        ),
        Image(
            image: AssetImage("assets/note.png"),
            height: MediaQuery.of(context).size.height * 0.5),
        Text(current_song.title, style: TextStyle(fontSize: 40)),
        Row(
          children: [
            SizedBox(width: 30),
            IconButton(
              iconSize: 70,
              icon: Icon(Icons.shuffle),
              onPressed: () {
                setState(() {
                  int _total = CURRENT_ACCOUNT.mySongs.length;
                  Random rng = new Random();
                  int _rand = rng.nextInt(_total);
                  current_song = CURRENT_ACCOUNT.mySongs[_rand];
                });
                // pick and switch to random track
              },
            ),
            SizedBox(width: 30),
            IconButton(
                icon: CURRENT_ACCOUNT.mySongs[index].play
                    ? Icon(MdiIcons.pause)
                    : Icon(MdiIcons.play),
                iconSize: 70,
                onPressed: () {
                  if (this.mounted) {
                    setState(() {
                      print("Duration of song: ${_duration}");
                      CURRENT_ACCOUNT.mySongs[index].play =
                          !CURRENT_ACCOUNT.mySongs[index].play;
                      for (int i = 0; i < CURRENT_ACCOUNT.mySongs.length; i++) {
                        if (CURRENT_ACCOUNT.mySongs[i].title ==
                            current_song.title) {
                          CURRENT_ACCOUNT.mySongs[i].play = current_song.play;
                          break;
                        }
                      }
                      if (CURRENT_ACCOUNT.mySongs[index].play) {
                        song_is_playing = true;
                        try {
                          print("Pos: ${pos.inSeconds}");
                          if (pos.inSeconds != null) {
                            if (pos.inSeconds < 1.0) {
                              playSong();
                            } else {
                              resume();
                            }
                          }
                        } catch (e) {
                          print("FATAL ERROR: $e");
                        }
                      } else {
                        try {
                          pos = _position;
                          song_is_playing = false;
                          player.pause();
                        } catch (e) {
                          print("FATAL ERROR: $e");
                        }
                      }
                    });
                  }
                }),
            SizedBox(width: 30),
            IconButton(
                icon: Icon(MdiIcons.pageNext),
                iconSize: 70,
                onPressed: () {
                  int nextIndex = index + 1;
                  current_song = CURRENT_ACCOUNT.mySongs[nextIndex];
                  // next song
                })
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.green[700],
            inactiveTrackColor: Colors.green[100],
            trackShape: RoundedRectSliderTrackShape(),
            trackHeight: 4.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
            thumbColor: Colors.greenAccent,
            overlayColor: Colors.green.withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            tickMarkShape: RoundSliderTickMarkShape(),
            activeTickMarkColor: Colors.green[700],
            inactiveTickMarkColor: Colors.green[100],
            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.greenAccent,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.black,
            ),
          ),
          child: Slider(
              min: 0.0,
              max: 30.0,
              value: volume,
              label: volume.toString(),
              onChanged: (value) {
                setState(() {
                  print("Set volume to: $volume");
                  volume = value;
                  player.setVolume(volume);
                });
              }),
        )
      ]),
    );
  }
}
