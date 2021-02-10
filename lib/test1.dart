import 'package:flutter/material.dart';

class Song {
  String title;
}

Song songClicked, song;
String lastSong;
bool playSong;

void test() {
  if (songClicked.title == lastSong) {
    if (playSong) {
      song.resume();
    } else {
      song.pause();
    }
  } else {
    if (playSong) {
      song.play();
    } else {
      song.stop();
    }
  }
}


CURRENT_ACCOUNT.mySongs[index].play =
                        !CURRENT_ACCOUNT.mySongs[index].play;
                    if (CURRENT_ACCOUNT.mySongs[index].play) {
                      song_is_playing = true;
                      if (pos.inSeconds == null) {
                        pos = _position;
                      }
                      if (pos.inSeconds < 1.0) {
                        print(
                            "Play song: ${CURRENT_ACCOUNT.mySongs[index].title}");
                        playSong(CURRENT_ACCOUNT.mySongs[index]);
                      } else {
                        print("Resume");
                        resume();
                      }
                    } else {
                      pos = new Duration();
                      song_is_playing = false;
                      player.stop();
                    }




                     //
                    /* CURRENT_ACCOUNT.mySongs[index].play =
                        !CURRENT_ACCOUNT.mySongs[index].play;
                    for (int l = 0; l < CURRENT_ACCOUNT.mySongs.length; l++) {
                      if (l != index) {
                        CURRENT_ACCOUNT.mySongs[l].play = false;
                      }
                    }
                    if (CURRENT_ACCOUNT.mySongs[index].play) {
                      song_is_playing = true;
                      if (pos.inSeconds != null) {
                        if (pos.inSeconds < 1.0) {
                          playSong();
                        } else {
                          resume();
                        }
                      }
                    } else {
                      pos = _position;
                      song_is_playing = false;
                      player.pause();
                    } */
