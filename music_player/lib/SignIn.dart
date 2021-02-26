import 'package:flutter/material.dart';
import 'SignUp.dart';
import 'accounts.dart';
import 'home.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignIn extends StatefulWidget {
  signIn createState() => signIn();
}

class signIn extends State<SignIn> {
  var usernameField = TextEditingController();
  var passwordField = TextEditingController();
  var _passwordField = TextEditingController();
  bool invalid = true;
  bool isEmpty = false;
  final invalidUsernamePassword = SnackBar(
    content: Text("Invalid username/password!"),
    duration: Duration(seconds: 3),
  );
  final empty = SnackBar(
    content: Text("You cannot leave these fields empty!"),
    duration: Duration(seconds: 3),
  );
  void initState() {
    invalid = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Icon(
          MdiIcons.account,
          color: Colors.grey[350],
          size: 150,
        ),
        Text(
          "Welcome back!",
          style: TextStyle(fontSize: 40),
        ),
        Text(
          "Sign in",
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 50),
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
        Row(
          children: [
            SizedBox(width: 70),
            Text("Forgot password? ", style: TextStyle(fontSize: 20)),
            GestureDetector(
                child: Text("Reset.",
                    style: TextStyle(color: Colors.orange, fontSize: 20)),
                onTap: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  });
                })
          ],
        ),
        SizedBox(height: 30),
        ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 300,
              minHeight: 43,
            ),
            child: MaterialButton(
                child: Text("Enter", style: TextStyle(fontSize: 20)),
                color: Colors.orange,
                onPressed: () {
                  setState(() {
                    if (usernameField.text.toString() == "" ||
                        passwordField.text.toString() == "") {
                      isEmpty = true;
                      ScaffoldMessenger.of(context).showSnackBar(empty);
                    } else {
                      isEmpty = false;
                    }
                    for (int i = 0; i < accounts.length; i++) {
                      if (usernameField.text.toString() ==
                          accounts[i].username) {
                        if (passwordField.text.toString() ==
                            accounts[i].password) {
                          print("Set to false");
                          CURRENT_ACCOUNT = accounts[i];
                          if (!isEmpty && !invalid) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                            invalid = false;
                          }
                        } else {
                          invalid = true;
                        }
                      } else {
                        invalid = true;
                      }
                    }
                    print("isEmpty: $isEmpty, invalid: $invalid");
                    if (invalid && !isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(invalidUsernamePassword);
                    }
                  });
                })),
        SizedBox(height: 30),
        Row(
          children: [
            SizedBox(width: 70),
            Text("Don't have an account? ", style: TextStyle(fontSize: 20)),
            GestureDetector(
                child: Text("Sign up!",
                    style: TextStyle(color: Colors.orange, fontSize: 20)),
                onTap: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  });
                })
          ],
        ),
      ],
    )));
  }
}
