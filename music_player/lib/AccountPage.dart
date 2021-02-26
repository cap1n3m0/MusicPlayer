import 'SignUp.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'main.dart';
import 'home.dart';
import 'AddSongs.dart';
import 'PlaylistPage.dart';
import 'SignIn.dart';
import 'favourites.dart';
import 'accounts.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  accountPage createState() => accountPage();
}

class accountPage extends State<AccountPage> {
  final clearedSongsSnackbar = new SnackBar(
    content: Text("Cleared all songs!"),
    duration: Duration(seconds: 3),
  );
  final clearedPlaylistsSnackbar = new SnackBar(
    content: Text("Cleared all playlists!"),
    duration: Duration(seconds: 3),
  );
  void initState() {
    super.initState();
    bottom_index = 4;
  }

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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => favouriteSongs()));
      } else {
        page = AppPage.account;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccountPage()));
      }
    });
  }

  Widget build(BuildContext context) {
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
                backgroundColor: Colors.lightGreenAccent,
                icon: Icon(
                  MdiIcons.account,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  MdiIcons.account,
                  color: Colors.lightGreenAccent,
                ),
                title: Text("My Account"))
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 70),
            Column(
              children: [
                Center(
                  child: Text(
                    "My Account",
                    style: TextStyle(fontSize: 70),
                  ),
                ),
              ],
            ),
            SizedBox(height: 35),
            Column(
              children: [
                Text("Account info", style: TextStyle(fontSize: 20)),
              ],
            ),
            Text(
                "Created On: ${CURRENT_ACCOUNT.day}/${CURRENT_ACCOUNT.month}/${CURRENT_ACCOUNT.year}",
                style: TextStyle(fontSize: 30)),
            SizedBox(height: 50),
            Text("Account settings", style: TextStyle(fontSize: 20)),
            Padding(
              padding: EdgeInsets.only(left: 50),
              child: ListTile(
                leading: Icon(MdiIcons.accountBox),
                title: Text("${CURRENT_ACCOUNT.username}"),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 50),
                child: ListTile(
                  leading: Icon(MdiIcons.key),
                  title: Text("${CURRENT_ACCOUNT.password}"),
                )),
            Padding(
                padding: EdgeInsets.only(left: 50),
                child: ListTile(
                  leading: Icon(MdiIcons.email),
                  title: Text("${CURRENT_ACCOUNT.email}"),
                )),
            SizedBox(height: 20),
            Text("Other", style: TextStyle(fontSize: 20)),
            SizedBox(height: 15),
            MaterialButton(
                color: Colors.red,
                child: Text("Delete all saved songs"),
                onPressed: () {
                  setState(() {
                    if (CURRENT_ACCOUNT.mySongs.length > 0) {
                      CURRENT_ACCOUNT.mySongs.clear();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(clearedSongsSnackbar);
                    }
                  });
                }),
            MaterialButton(
                color: Colors.red,
                child: Text("Delete all saved playlists"),
                onPressed: () {
                  setState(() {
                    if (CURRENT_ACCOUNT.myPlaylists.length > 0) {
                      CURRENT_ACCOUNT.myPlaylists.clear();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(clearedPlaylistsSnackbar);
                    }
                  });
                }),
            MaterialButton(
                onPressed: () {
                  setState(() {
                    CURRENT_ACCOUNT.fetched = 0;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  });
                },
                child: MaterialButton(
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                    });
                  },
                  child: Text("Sign out"),
                ))
          ],
        ));
  }
}
