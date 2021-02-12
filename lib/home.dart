import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'AddSongs.dart';
import 'Favourites.dart';
import 'songs.dart';
import 'dart:math';
import 'main.dart';
import 'PlaylistPage.dart';
import 'SongDetails.dart';
import 'package:http/http.dart' as http;
import 'AccountPage.dart';
import 'accounts.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:web_scraper/web_scraper.dart';

// problem: need to tell it to stop and not pause

String lastSong = "";

class HomePage extends StatefulWidget {
  Home createState() => Home();
}

class Home extends State<HomePage> {
  Duration dur = new Duration();
  static Duration pos = new Duration();
  AudioCache cache;
  AudioPlayer player;
  Duration _position = new Duration();
  Duration _duration = new Duration();
  bool show_floating_button;
  bool isDisposed = false;
  bool fetched = false;
  bool isCheckingArtists = false;
  var fixedController = new FixedExtentScrollController();
  final songScraper = WebScraper(url);

  void fetch() async {
    List<String> _temp = [];
    final doc = await http.get("$url/$artistsExtension");
    dom.Document document = parser.parse(doc.body);
    final elements = document.getElementsByClassName('para');
    setState(() {
      _temp = elements
          .map((element) => element.getElementsByTagName('p')[0].innerHtml)
          .toList();
    });
    _temp[0] = _temp[0].replaceAll(" ", "");
    String add = "";
    for (int i = 0; i < _temp[0].length - 1; i++) {
      if (_temp[0][i] == ',') {
        artists.add(add);
        add = "";
      } else {
        add += _temp[0][i];
      }
    }
    CURRENT_ACCOUNT.fetched++;
    if (await songScraper.loadWebPage('')) {
      setState(() {
        scrapedSongs = songScraper.getElement('p', []).toString();
        scrapedSongs = scrapedSongs.replaceAll("title: ", "");
        scrapedSongs = scrapedSongs.replaceAll("attributes: ", "");
        scrapedSongs = scrapedSongs.replaceAll("{", "");
        scrapedSongs = scrapedSongs.replaceAll("}", "");
        scrapedSongs = scrapedSongs.replaceAll("[", "");
        scrapedSongs = scrapedSongs.replaceAll("]", "");
        scrapedSongs = scrapedSongs.replaceAll(", h", "h");
        scrapedSongs = scrapedSongs.replaceAll(" ", "");
        scrapedSongs = scrapedSongs.replaceAll("$url/", "");
        String newSong = "";
        for (int i = 0; i < scrapedSongs.length - 1; i++) {
          if (scrapedSongs[i] == ',') {
            song_names.add(newSong.replaceAll(".mp3", ""));
            song_links.add(url + "/" + newSong);
            var _s = newSong.replaceAll(".mp3", "");
            NameLink[newSong] = url + "/" + _s + ".mp3";
            newSong = "";
          } else {
            newSong += scrapedSongs[i];
            newSong = newSong.replaceAll(".mp3", "");
          }
        }
      });
    }
    for (int i = 0; i < song_names.length; i++) {
      NameArtist[song_names[i]] = artists[i];
    }
    for (int i = 0; i < song_names.length; i++) {
      all_songs.add(new Song(
          song_names[i], NameLink[song_names[i]], NameArtist[song_names[i]]));
    }
    for (int i = 0; i < 5; i++) {
      CURRENT_ACCOUNT.mySongs.add(new Song(
          song_names[i], NameLink[song_names[i]], NameArtist[song_names[i]]));
    }
    for (int i = 0; i < song_names.length - 1; i++) {
      NameArtist[song_names[i]] = artists[i];
    }
    NameArtist["Believer"] = "ImagineDragons";
    CURRENT_ACCOUNT.fetched++;
  }

  void initState() {
    super.initState();
    for (int i = 0; i < accounts.length; i++) {
      print("${accounts[i].username}");
      print(accounts[i].month);
      print(accounts[i].year);
    }
    show_floating_button = true;
    player = new AudioPlayer();
    cache = new AudioCache(fixedPlayer: player);
    bottom_index = 0;
    if (CURRENT_ACCOUNT.fetched < 2) {
      fetch();
      print("Fetched");
    }
  }

  void seekToSecond(var value) async {
    player.seek(new Duration(seconds: value.toInt()));
    value = value;
  }

  void onTapped(int index) {
    setState(() {
      bottom_index = index;
    });
  }

  void release() async {
    await player.release();
  }

  void dispose() async {
    if (!isDisposed) {
      await player.dispose();
      isDisposed = true;
    }
  }

  Widget recent_songs() {
    void play_song(RECENT) {
      player.play(RECENT.file);
    }

    return CURRENT_ACCOUNT.recents.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: CURRENT_ACCOUNT.recents.length,
            itemBuilder: (context, index) {
              Song RECENT = CURRENT_ACCOUNT.recents[index];
              Song LINK;
              for (var i in CURRENT_ACCOUNT.mySongs) {
                if (i.title == RECENT.title) {
                  LINK = i;
                }
              }
              return Card(
                  child: ListTile(
                leading: IconButton(
                    color: Colors.red,
                    icon: Icon(
                      RECENT.play ? MdiIcons.pause : MdiIcons.play,
                    ),
                    onPressed: () {
                      setState(() {
                        RECENT.play = !RECENT.play;
                        if (RECENT.title == lastSong) {
                          if (pos.inSeconds == null) {
                            pos = _position;
                          }
                          if (RECENT.play) {
                            player.resume();
                            for (var i in CURRENT_ACCOUNT.mySongs) {
                              if (i != RECENT) {
                                i.play = false;
                              }
                            }
                          } else {
                            song_is_playing = false;
                            player.pause();
                          }
                        } else {
                          if (RECENT.play) {
                            player.play(RECENT.file);
                            lastSong = RECENT.title;
                            for (var i in CURRENT_ACCOUNT.mySongs) {
                              if (i != RECENT) {
                                i.play = false;
                              }
                            }
                          } else {
                            song_is_playing = false;
                            player.stop();
                          }
                        }
                        int legnth = CURRENT_ACCOUNT.favourites.length;
                        for (int l = 0; l < legnth; l++) {
                          if (l != index) {
                            RECENT.play = false;
                          }
                        }
                      });
                    }),
                title: Text(RECENT.title),
                subtitle: Text(RECENT.artist),
              ));
            },
          )
        : Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text("No Recents",
                style: TextStyle(
                  fontSize: 20,
                )));
  }

  Widget my_songs() {
    return ListView(children: [
      Container(
        padding: EdgeInsets.only(left: 30),
        height: 60,
        child: Text(
          'Recents',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      recent_songs(),
      SizedBox(height: 30),
      Container(
        padding: EdgeInsets.only(left: 30),
        height: 60,
        child: Text(
          'My Songs',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 500),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: CURRENT_ACCOUNT.mySongs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    child: CURRENT_ACCOUNT.mySongs.length > 0
                        ? song(context, index)
                        : null,
                    onTap: () {
                      player.stop();
                      current_song = CURRENT_ACCOUNT.mySongs[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SongDetails(
                                    player: player,
                                    cache: cache,
                                    play: current_song.play,
                                    index: index,
                                  )));
                    });
              })),
    ]);
  }

  Widget search_bar() {
    return TextField(
      decoration: InputDecoration(
          hintText: "Search songs",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }

  Widget song(context, index) {
    bool f = false;
    Song songToPlay = CURRENT_ACCOUNT.mySongs[index];
    void playSong() {
      print("Should play: ${songToPlay.title}");
      for (int i = 0; i < CURRENT_ACCOUNT.mySongs.length; i++) {
        if (CURRENT_ACCOUNT.mySongs[i] != songToPlay) {
          CURRENT_ACCOUNT.mySongs[i].play = false;
        } else {}
      }
      setState(() {
        player.durationHandler = (_d) => setState(() {
              _duration = _d;
            });
        player.positionHandler = (_p) => setState(() {
              _position = _p;
            });
        player.play(songToPlay.file);
        _position = pos;
        seekToSecond(pos.inSeconds);
        for (int i = 0; i < CURRENT_ACCOUNT.recents.length; i++) {
          if (CURRENT_ACCOUNT.recents[i] == songToPlay) {
            f = true;
          }
        }
        if (!f) {
          CURRENT_ACCOUNT.recents.add(songToPlay);
        }
        if (CURRENT_ACCOUNT.recents.length > 3) {
          CURRENT_ACCOUNT.recents.remove(songToPlay);
        }
      });
    }

    void resume() async {
      await player.resume();
    }

    void release() async {
      await player.release();
    }

    void dispose() async {
      if (!isDisposed) {
        await player.dispose();
        isDisposed = true;
      }
    }

    player.onDurationChanged.listen((Duration _dur) {
      setState(() {
        current_song.duration = _dur;
      });
      player.onAudioPositionChanged.listen((Duration _pos) {
        setState(() {
          _position = _pos;
        });
      });
    });

    if (CURRENT_ACCOUNT.mySongs[index].play == null) {
      CURRENT_ACCOUNT.mySongs[index].play = false;
    }
    return Card(
        child: ListTile(
            leading: IconButton(
                color: Colors.red,
                icon: Icon(
                  CURRENT_ACCOUNT.mySongs[index].play
                      ? MdiIcons.pause
                      : MdiIcons.play,
                ),
                onPressed: () {
                  if (songToPlay.play == null) {
                    songToPlay.play = false;
                  }
                  songToPlay.play = !songToPlay.play;
                  print(songToPlay.title);
                  print(lastSong);
                  setState(() {
                    if (songToPlay.title == lastSong) {
                      if (pos.inSeconds == null) {
                        pos = _position;
                      }
                      if (songToPlay.play) {
                        player.resume();
                        for (var i in CURRENT_ACCOUNT.mySongs) {
                          if (i != songToPlay) {
                            i.play = false;
                          }
                        }
                      } else {
                        song_is_playing = false;
                        player.pause();
                      }
                    } else {
                      if (songToPlay.play) {
                        player.play(songToPlay.file);
                        lastSong = songToPlay.title;
                        if (CURRENT_ACCOUNT.recents.length < 3) {
                          CURRENT_ACCOUNT.recents.add(songToPlay);
                          CURRENT_ACCOUNT
                              .recents[CURRENT_ACCOUNT.recents.length - 1]
                              .play = songToPlay.play;
                        }
                        for (var i in CURRENT_ACCOUNT.mySongs) {
                          if (i != songToPlay) {
                            i.play = false;
                          }
                        }
                      } else {
                        song_is_playing = false;
                        player.stop();
                      }
                    }
                  });
                }),
            title: Text(CURRENT_ACCOUNT.mySongs[index].title),
            subtitle: Text(CURRENT_ACCOUNT.mySongs[index].artist),
            trailing: IconButton(
                icon: CURRENT_ACCOUNT.mySongs[index].fav == Fav.f
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_outline),
                color: CURRENT_ACCOUNT.mySongs[index].fav == Fav.f
                    ? Colors.red
                    : null,
                onPressed: () {
                  setState(() {
                    if (CURRENT_ACCOUNT.mySongs[index].fav == Fav.f) {
                      CURRENT_ACCOUNT.mySongs[index].fav = Fav.n;
                      if (CURRENT_ACCOUNT.favourites.length > 0) {
                        for (int i = 0;
                            i < CURRENT_ACCOUNT.favourites.length;
                            i++) {
                          if (CURRENT_ACCOUNT.favourites[i] ==
                              CURRENT_ACCOUNT.mySongs[index]) {
                            CURRENT_ACCOUNT.favourites.remove(CURRENT_ACCOUNT
                                .favourites[i]); // remove from fav songs
                          }
                        }
                      }
                    } else {
                      CURRENT_ACCOUNT.mySongs[index].fav = Fav.f;
                      bool _found = false;
                      for (int i = 0;
                          i < CURRENT_ACCOUNT.favourites.length;
                          i++) {
                        if (CURRENT_ACCOUNT.favourites[i] ==
                            CURRENT_ACCOUNT.mySongs[index]) {
                          _found = true;
                          break;
                        }
                      }
                      if (!_found) {
                        CURRENT_ACCOUNT.favourites
                            .add(CURRENT_ACCOUNT.mySongs[index]);
                        for (int i = 0;
                            i < CURRENT_ACCOUNT.favourites.length;
                            i++) {
                          if (CURRENT_ACCOUNT.favourites[i] ==
                              CURRENT_ACCOUNT.mySongs[index]) {
                            CURRENT_ACCOUNT.favourites[i].fav = Fav.f;
                            break;
                          }
                        }
                      }
                    }
                  });
                })));
  }

  void check() {
    for (int i = 0; i < CURRENT_ACCOUNT.mySongs.length; i++) {
      for (int j = CURRENT_ACCOUNT.mySongs.length - 1; j >= 0; j--) {
        if (CURRENT_ACCOUNT.mySongs[i].title ==
                CURRENT_ACCOUNT.mySongs[j].title &&
            i != j) {
          CURRENT_ACCOUNT.mySongs.removeAt(j);
        }
      }
    }
  }

  void sort() {
    CURRENT_ACCOUNT.mySongs.sort((a, b) => a.title.compareTo(b.title));
  }

  Widget build(BuildContext context) {
    check();
    sort();
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

    show_floating_button = page == AppPage.home;
    return Scaffold(
        body: CURRENT_ACCOUNT.mySongs.length > 0 ? my_songs() : new Container(),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: show_floating_button
            ? FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(Icons.shuffle),
                onPressed: () {
                  if (page == AppPage.home) {
                    if (CURRENT_ACCOUNT.mySongs.length > 0) {
                      setState(() {
                        var rand =
                            Random().nextInt(CURRENT_ACCOUNT.mySongs.length);
                        CURRENT_ACCOUNT.mySongs[rand - 1].play =
                            !CURRENT_ACCOUNT.mySongs[rand - 1].play;
                        for (int l = 0;
                            l < CURRENT_ACCOUNT.mySongs.length;
                            l++) {
                          if (l != rand - 1) {
                            CURRENT_ACCOUNT.mySongs[l].play = false;
                          }
                        }
                        if (CURRENT_ACCOUNT.mySongs[rand - 1].play) {
                          if (CURRENT_ACCOUNT.mySongs[rand - 1].midway) {
                            player.resume();
                          } else {
                            player.play(CURRENT_ACCOUNT.mySongs[rand - 1].file);
                          }
                        } else {
                          player.pause();
                        }
                      });
                    }
                  }
                })
            : null);
  }
}
