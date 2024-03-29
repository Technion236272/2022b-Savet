import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Services/user_db.dart';
import '../homepage.dart';
import 'auth_repository.dart';

class Register extends StatefulWidget {
  Register({Key? key, required this.LogFrom}) : super(key: key);
  String LogFrom;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // void addToken(String email) {
  //   var auth = FirebaseAuth.instance;
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   messaging.getToken().then((token) {
  //     final FirebaseFirestore db = FirebaseFirestore.instance;
  //     return db
  //         .collection('users')
  //         .where('token', isEqualTo: token)
  //         .get()
  //         .then((snapshot) async {
  //       if (snapshot.docs.isEmpty) {
  //         return db
  //             .collection('users')
  //             .doc(email)
  //             .set({'token': token}).then((value) => null);
  //       }
  //     });
  //   });
  // }

  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmpassword = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _username = new TextEditingController();
  @override
  void initState() {
    super.initState();
    AuthRepository.instance();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _confirmpassword = TextEditingController(text: "");
    _username = TextEditingController(text: "");
    print("Register page");
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          centerTitle: false,
        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            return RegisterScreen();
          },
        ));
  }

  Widget RegisterScreen() {
    final user = Provider.of<AuthRepository>(context);
    return SingleChildScrollView(
      child: Center(
          child: SizedBox(
        // width:  height: MediaQuery.of(context).size.width*0.1,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            const Text(''),
            const SizedBox(height: 20),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Material(
                elevation: 3,
                shadowColor: Colors.black,
                child: TextField(
                  controller: _username,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                    labelText: 'Username',
                    fillColor: Colors.black12,
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Please enter your user name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 15,
                  bottom: 0), //adding:  EdgeInsets.symmetric(horizontal: 15),
              child: Material(
                elevation: 3,
                shadowColor: Colors.black,
                child: TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                    labelText: 'Email',
                    fillColor: Colors.black12,
                    filled: true,
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Please enter your Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: Material(
                elevation: 3,
                shadowColor: Colors.black,
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Enter your password',
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: Material(
                elevation: 3,
                shadowColor: Colors.black,
                child: TextField(
                  controller: _confirmpassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const Text(''),
            const Text(''),
            user.status == Status.Authenticating
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                        child: const Text(
                          'Confirm',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        onPressed: () async {
                          try {
                            _password.text == _confirmpassword.text &&
                                    _password.text != '' &&
                                    _confirmpassword.text != ''
                                ? {
                                    if (await user.signUp(_email.text,
                                            _password.text, _username.text) !=
                                        null)
                                      {
                                        FirebaseMessaging.instance
                                            .getToken()
                                            .then((token) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(_email.text)
                                              .set({
                                            'username': _username.text,
                                            'log_from': "Email",
                                            'token': token
                                          });
                                        }),
                                        setState(() {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FutureBuilder(
                                                          future: Provider.of<
                                                                      UserDB>(
                                                                  context)
                                                              .fetchData(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasError) {
                                                              return Center(
                                                                  child: Text(
                                                                      snapshot
                                                                          .error
                                                                          .toString()));
                                                            } else if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .done) {
                                                              return homepage(
                                                                  LoginFrom:
                                                                      "Email");
                                                            }
                                                            return const Center(
                                                                child:
                                                                    CircularProgressIndicator());
                                                          })));
                                        }),
                                      }
                                    else
                                      {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    ('The user is already signed up'))))
                                      }
                                  }
                                : {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text(('Passwords must match'))))
                                  };
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(fix(e.toString()))));
                          }
                        }),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(20)),
                  ),
          ],
        ),
      )),
    );
  }

  String fix(String s) {
    int i = 0;
    for (; i < s.length; i++) {
      if (s[i] == ']') break;
    }

    String result = s.replaceRange(0, i + 2, '');
    // String result = s.replaceAll(RegExp('([.*])'), '');
    print(s);
    print(result);
    return result;
  }
}
