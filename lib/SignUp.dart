import 'package:flutter/material.dart';
import 'package:flutter_application_1/SharedPrefs.dart';
import 'package:flutter_application_1/accounts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'home.dart';
import 'test.dart';
import 'SignIn.dart';

class SignUp extends StatefulWidget {
  signUp createState() => signUp();
}

class signUp extends State<SignUp> {
  var usernameField = TextEditingController();
  var passwordField = TextEditingController();
  var _passwordField = TextEditingController();
  var emailField = TextEditingController();
  final day = DateTime.now().day.toString();
  final month = DateTime.now().month.toString();
  final year = DateTime.now().year.toString();
  bool invalid = true;
  bool isEmpty = true;
  bool exists = false;
  final doNotMatch = SnackBar(
    content: Text("Passwords do not match!"),
    duration: Duration(seconds: 3),
  );
  final empty = SnackBar(
    content: Text("These fields cannot be left empty!"),
    duration: Duration(seconds: 3),
  );
  final alreadyExists = SnackBar(
    content: Text("Error: Account exists!"),
    duration: Duration(seconds: 3),
  );

  void initState() {
    super.initState();
    invalid = false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 100),
            child: Icon(
              MdiIcons.account,
              color: Colors.grey[350],
              size: 150,
            )),
        Center(
            child: Column(children: [
          Text(
            "Create new account",
            style: TextStyle(fontSize: 40),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: Container(
              child: TextFormField(
                controller: usernameField,
                decoration: InputDecoration(
                  hintText: "Enter username: ",
                  prefixIcon: Icon(MdiIcons.accountBox),
                ),
                onChanged: (value) {
                  setState(() {
                    invalid = false;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 40),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: Container(
              child: TextFormField(
                controller: emailField,
                decoration: InputDecoration(
                  hintText: "Enter Email: ",
                  prefixIcon: Icon(MdiIcons.email),
                ),
                onChanged: (value) {
                  setState(() {
                    invalid = false;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 40),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: Container(
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter password: ",
                  prefixIcon: Icon(MdiIcons.lock),
                ),
                controller: passwordField,
              ),
            ),
          ),
          SizedBox(height: 40),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: Container(
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter password again: ",
                  prefixIcon: Icon(MdiIcons.repeat),
                ),
                controller: _passwordField,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 43,
              ),
              child: MaterialButton(
                  minWidth: 300,
                  child: Text("Enter",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  color: Colors.orange,
                  onPressed: () {
                    setState(() {
                      if (usernameField.text.toString() != null &&
                          usernameField.text.toString() != "" &&
                          usernameField.text.toString() != null &&
                          usernameField.text.toString() != "" &&
                          usernameField.text.toString() != null &&
                          usernameField.text.toString() != "") {
                        isEmpty = false;
                      } else {
                        isEmpty = true;
                      }
                      if (passwordField.text.toString() ==
                          _passwordField.text.toString()) {
                        invalid = false;
                      } else {
                        invalid = true;
                      }
                      for (int i = 1; i < accounts.length; i++) {
                        print(accounts[i].username);
                        if (usernameField.text.toString() ==
                            accounts[i].username.toString()) {
                          print("account exists");
                          exists = true;
                          break;
                        } else {
                          exists = false;
                        }
                      }
                      if (isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(empty);
                      } else {
                        if (invalid) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(doNotMatch);
                        } else if (exists) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(alreadyExists);
                        } else {
                          accounts.add(
                            new Account(
                              usernameField.text.toString(),
                              passwordField.text.toString(),
                              accounts.length,
                              DateTime.now().day.toString(),
                              DateTime.now().month.toString(),
                              DateTime.now().year.toString(),
                              emailField.text.toString(),
                            ),
                          );
                          CURRENT_ACCOUNT = accounts[accounts.length - 1];
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }
                      }
                    });
                  })),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 70),
              Text("Already have an account? ", style: TextStyle(fontSize: 20)),
              GestureDetector(
                  child: Text("Sign in!",
                      style: TextStyle(color: Colors.orange, fontSize: 20)),
                  onTap: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                    });
                  })
            ],
          ),
        ]))
      ],
    ));
  }
}
