import 'package:flutter/material.dart';
//import 'package:demo/Animation/FadeAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/HomePage.dart';
import 'package:login_page/database.dart';
import 'package:login_page/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import  'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        home:LoginPage()
    )
);
class LoginPage extends StatefulWidget {
  const LoginPage({Key key, this.onSignedIn});
  final VoidCallback onSignedIn;
  @override
  LoginPageState createState() => new LoginPageState();
}
class LoginPageState extends State<LoginPage> {
  String email, password;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
 // final FirebaseUser User = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.orange[900],
                  Colors.orange[800],
                  Colors.orange[400]
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 35),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Text("Login",
                    style: TextStyle(color: Colors.white, fontSize: 40),),
                  SizedBox(height: 10,),
                  Text("Welcome Back",
                    style: TextStyle(color: Colors.white, fontSize: 18),),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0,),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(
                          color: Color.fromRGBO(50, 50, 50, .85),
                          blurRadius: 20,
                          offset: Offset(0, 10)
                      )
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60))
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 30,),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .5),
                                    blurRadius: 20,
                                    offset: Offset(0, 10)
                                )
                                ]
                            ),
                            child: Form(
                              key: formkey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            color: Colors.grey[200]))
                                    ),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: "Enter your E-Mail ",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return "Please type email";
                                        }
                                      },
                                      // validator:(value)=>value.isEmpty?'Email cant be empty':null,
                                      onChanged: (input) => email = input,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            color: Colors.grey[200]))
                                    ),
                                    child: TextFormField(
                                      obscureText: true,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                          hintText: "Enter your Password",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Please type password';
                                        }
                                      },
                                      // validator:(value)=>value.isEmpty?'Password cant be empty':null,
                                      onChanged: (input) => password = input,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 40,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child: Center(
                              child: RaisedButton(
                                child: Text('Login', style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                color: Colors.orange[700],
                                splashColor: Colors.lightGreen,
                                elevation: 12.0,
                                onPressed: () {
                                  signIn();
                                  print(email);
                                  print(password);
                                  //  validateAndSave();}
                                  //print('Clicked')
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text("Don't have an account- Sign up now ",
                            style: TextStyle(color: Colors.grey),),
                          SizedBox(height: 10,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child: Center(
                              child: RaisedButton(
                                  child: Text('Sign up', style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  color: Colors.blue,
                                  splashColor: Colors.lightGreen,
                                  elevation: 11.0,
                                  onPressed: () {
                                    print('Clicked');
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => SignUp())
                                    );
                                  }
                              ),
                            ),
                          ),
                          /*  Row(
                        children: <Widget>[
                          Expanded(
                            child:Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              child:Center(
                              child:RaisedButton(onPressed: (){
                                print('Clicked');
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUp())
                                );
                              },
                              child:Text('Sign Up',style: TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(50) ),
                              splashColor: Colors.lightGreen,
                              ),
                            ),
                            ),
                          ),
                         SizedBox(width:30,),
                          /*Expanded(
                            child:Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius:BorderRadius.circular(50),
                                color:Colors.black
                              ),
                              child:Center(
                               child:Text("Forgot Password" ,style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),
                            ),
                            ),
                          ),*/
                       // ],
                       //)*/
                        ],),
                    ),
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }

  /*Future<void> signIn() async
  {
    final formState=formkey.currentState;
    if(formState.validate())
    {
      formState.save();
      try {
        AuthResult user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email, password: password) ;
        print(user);
        widget.onSignedIn();
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      }catch(e){
        print(e.message);
      }
    }
  }*/
  Future<void> signIn() async {
    final formState = formkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        final user = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(user);
        String UserId=(await FirebaseAuth.instance.currentUser()).uid;
        //print(UserId);
        //widget.onSignedIn();
       // Navigator.of(context).pop();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FriendFragment()));
      }
      catch (e) {
        print(e.message);
      }
    }
  }
}
class SignUp extends StatefulWidget {
  SignUpLayout createState() => SignUpLayout();
}
class SignUpLayout extends State<SignUp>{
  String email,password,cpassword,username;
  final GlobalKey<FormState> formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical:10),
        decoration: BoxDecoration(
            gradient:LinearGradient(
                colors:[
                  Colors.green[900],
                  Colors.green[800],
                  Colors.green[400]
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            SizedBox(height:35,),
            Padding(
              padding: EdgeInsets.all(15),
              child:Column(
                children:<Widget>[
                  Text("Sign Up",style:TextStyle(color: Colors.white,fontSize: 40),),
                  SizedBox(height: 10,),
                  Text("Enroll Yourself",style:TextStyle(color: Colors.white,fontSize: 18),),
                ],
              ),
            ),
            SizedBox(height:20,),
            Expanded(
              child:Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0,),
                decoration:BoxDecoration(
                    color:Colors.white,
                    boxShadow: [BoxShadow(
                        color:Color.fromRGBO(50, 50, 50,.85),
                        blurRadius: 20,
                        offset:Offset(0,10)
                    )],
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(60),topRight:Radius.circular(60),bottomLeft: Radius.circular(60),bottomRight: Radius.circular(60))
                ),
                child: Padding(
                  padding:EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    child: Column(
                      children:<Widget>[
                        SizedBox(height :30,),
                        Container(
                          decoration:BoxDecoration(
                              color: Colors.white,
                              borderRadius:BorderRadius.circular(10),
                              boxShadow:[BoxShadow(
                                  color:Color.fromRGBO(95, 225, 27,.5),
                                  blurRadius: 20,
                                  offset:Offset(0,10)
                              )]
                          ),
                          child:Form(
                            key: formkey,
                            child: Column(
                              children:<Widget>[
                                // Text('Email',style:TextStyle(color: Colors.grey,fontSize: 10)),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border:Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        hintText: "E-Mail ",
                                        hintStyle:TextStyle(color:Colors.grey),
                                        border:InputBorder.none,
                                    ),
                                    validator:(input) {
                                      if(input.isEmpty){
                                        return 'Please type email';
                                      }
                                    },
                                    onChanged: (input) => email=input ,
                                  ) ,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border:Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "USERNAME",
                                        hintStyle:TextStyle(color:Colors.grey),
                                        border:InputBorder.none
                                    ),
                                   validator:(input) {
                                      if(input.isEmpty){
                                        return 'Please type Username';
                                      }
                                    },
                                    onChanged: (input) => username=input ,
                                  ) ,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border:Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        hintText: "PASSWORD",
                                        hintStyle:TextStyle(color:Colors.grey),
                                        border:InputBorder.none
                                    ),

                                   validator:(input){
                                      if(input.isEmpty){
                                        return 'Please type password';
                                      }
                                    },
                                    onChanged: (input) => password=input ,
                                  ) ,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border:Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        hintText: "CONFIRM-PASSWORD",
                                        hintStyle:TextStyle(color:Colors.grey),
                                        border:InputBorder.none
                                    ),

                                   validator:(input) {
                                      if(input.isEmpty){
                                        return 'Please type password again';
                                      }
                                      else if(password!=cpassword){
                                        return 'Password doesnt match';
                                      }
                                    },
                                    onChanged: (input) => cpassword=input ,
                                  ) ,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:20,),
                        Row(
                            children:<Widget>[
                              // Expanded(
                              SizedBox(
                                width: 120,
                                child:Center(
                                  child:RaisedButton(
                                      child: Text('Register',style: TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),
                                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(50) ),
                                      color: Colors.green[800],
                                      splashColor: Colors.lightGreen,
                                      elevation: 12.0,
                                      onPressed: (){
                                        print('Clicked');
                                        signUp();
                                        print(email);
                                        print(password);
                                      },
                                  ),
                                ),
                              ),
                              SizedBox(width:30),
                              //  Expanded(
                              SizedBox(
                                //width: 120,
                                child:Center(
                                  child:RaisedButton(
                                      child: Text('Back to Login',style: TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),
                                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(50) ),
                                      color: Colors.black,
                                      splashColor: Colors.lightGreen,
                                      elevation: 12.0,
                                      onPressed: (){
                                        print('Clicked');
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage())
                                        );
                                      }
                                  ),
                                ),
                              ),
                            ]
                        )


                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> signUp() async
  {
    final formState=formkey.currentState;
    if(formState.validate())
    {
      formState.save();
      try {
        AuthResult user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: email, password: password) ;
        String uid = (await FirebaseAuth.instance.currentUser()).uid;
        await DatbaseSevice(uid: user.user.uid).updateUserData(email,username,uid);
        user.user.sendEmailVerification();
        Navigator.of(context).pop();
        print(user.user.email);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      }catch(e){
        print(e.message);
      }
    }
  }


}

/*class LoginPageState extends State<LoginPage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(currentUserId: prefs.getString('id'))),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result =
      await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance.collection('users').document(firebaseUser.uid).setData({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen(currentUserId: firebaseUser.uid)));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: FlatButton(
                  onPressed: handleSignIn,
                  child: Text(
                    'SIGN IN WITH GOOGLE',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Color(0xffdd4b39),
                  highlightColor: Color(0xffff7f7f),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
            ),

            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                ),
                color: Colors.white.withOpacity(0.8),
              )
                  : Container(),
            ),
          ],
        ));
  }
}
*/



