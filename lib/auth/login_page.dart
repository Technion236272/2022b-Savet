import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:savet/auth/Register.dart';
import 'ResetPassword.dart';
import 'auth_repoitory.dart';
import 'package:provider/provider.dart';
import 'Home.dart';
import 'Register.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/painting/image_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  //final AccessToken _accessToken;

  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _password =new TextEditingController();
  TextEditingController _email = new TextEditingController();

  @override
  void initState() {
    super.initState();
    AuthRepository.instance();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    print("Login in");
  }

  Future<FirebaseApp> _initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Login'),centerTitle:false,
          automaticallyImplyLeading: false,

        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot){
            return LoginScreen();

            if(snapshot.connectionState == ConnectionState.done){
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
    );
  }

  Widget LoginScreen(){
    final user = Provider.of<AuthRepository>(context);
    // if(user.isAuthenticated)
    //   user.signOut();
    return SingleChildScrollView(
      child: Center(
          child: SizedBox(
           // width:  height: MediaQuery.of(context).size.width*0.1,
          width: MediaQuery.of(context).size.width*0.9,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                const Text(''),
                const SizedBox(height: 20),

                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding:  EdgeInsets.symmetric(horizontal: 15),
                  child:Material(
                    elevation: 3,
                    shadowColor: Colors.black,
                    child:TextField(
                    controller: _email,
                    decoration:  const InputDecoration(
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
                  child:Material(
                    elevation: 3,
                    shadowColor: Colors.black,
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    decoration:  const InputDecoration(
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
                      left: 215.0),
                  child:TextButton(
                    child: Text("forget password?"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ResetPassword()));

                    }
                  )
                ),

                const Text(''),
                user.status==Status.Authenticating ? const Center(
                  child: CircularProgressIndicator(),
                ) :
                Container(
                  height: MediaQuery.of(context).size.width*0.1,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    child: const Text('Log in',style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    onPressed: () async {
                      await user.signIn(_email.text, _password.text);
                      (user.isAuthenticated) ?
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Flutter Demo Home Page')))
                          :
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Error to Log in')));
                    },
                  ),

                  decoration: BoxDecoration(
                      color: Colors.deepOrange, borderRadius: BorderRadius.circular(20)

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15.0),
                  //padding:  EdgeInsets.symmetric(horizontal: 15),
                    child:TextButton(
                        child: const Text("Login as a guest", style: TextStyle(color: Colors.black54),),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Flutter Demo Home Page')));

                        }
                    )
                ),


                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15.0,top:80.0),
                  //padding:  EdgeInsets.symmetric(horizontal: 15),

                  child: Row(
                      children: <Widget> [
                        Expanded(
                          flex: 1,
                          child: FlatButton(
                            onPressed: () {
                                   Navigator.push(
                                       context,
                                     MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Flutter Demo Home Page')));
                                  },
                            child: Image.asset('assets/image/facebook.png'
                            ,height: 70,width: 70,
                            ),
                          ),
                        ),

                        Expanded(
                          flex:1,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Flutter Demo Home Page')));

                            },
                            child:  Image.asset('assets/image/google.png'
                              ,height: 100,width: 100,
                            ),
                          ),
                        ),
                      ]
                  ),
                ),

                //Register
                Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15.0,top: 150),
                    //padding:  EdgeInsets.symmetric(horizontal: 15),

                  child: RichText(
                text:  TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
            children: [
              const TextSpan(text: "Don't have an account ? ",style: TextStyle(color: Colors.black)),
              TextSpan(text: 'Register', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  recognizer: TapGestureRecognizer()..onTap = () {
                   print('Register Tap');
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Register()));
                    });

                     }

              ),
            ],
          ),

                ),
                ),


              ],
            ),
          )
      ),
    );
  }

// @override
// void dispose() {
//   print("Login Out");
//   _email.dispose();
//   _password.dispose();
//   super.dispose();
// }

}