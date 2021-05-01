import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'auth_provider.dart';
import 'crud.dart';
import 'package:login_page/widgets/recent_chats.dart';
import 'package:login_page/widgets/category_selector.dart';
import 'package:login_page/chatting.dart';
import 'package:pie_chart/pie_chart.dart';

var snapShots;
var snapsnap;
var update;
String uid;
crudMethods crudObj = new crudMethods();
DocumentSnapshot document;

class FriendFragment extends StatefulWidget {
  @override
  _FriendFragmentState createState() => _FriendFragmentState();
}

class _FriendFragmentState extends State<FriendFragment>
    with SingleTickerProviderStateMixin {
  String result, email, Username, status = '0';
  TabController _tabController;
  DocumentSnapshot snap;
  bool showEmail = false;
  bool showUser = false;
  @override
  void initState() {
    super.initState();
    getData();
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelector);
  }

//  void getData() async {
//    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    uid = user.uid.toString();
//    print(uid);
//  }

  void getData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid.toString();
    print(uid);
    try {
      snap = await Firestore.instance.collection('Users').document(uid).get();
    } catch (e) {
      print('Hi');
    }
    setState(() {
      email = snap.data['Email'];
      Username = snap.data['Username'];
      showEmail = true;
      showUser = true;
    });
    print(email);
    print(Username);
    // snapshot=await Firestore.instance.collection('Users').getDocuments();
    //print(UserId);
  }

  void _handleTabSelector() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[600],
          automaticallyImplyLeading: true,
          elevation: 0.0,
          title: Text(
            'We Vote',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
//          bottom: TabBar(
//            controller: _tabController,
//            isScrollable: false,
//            indicatorWeight: 7.0,
//            indicatorColor: Colors.white,
//            unselectedLabelColor: Colors.grey,
//            tabs: <Widget>[
//              Tab(
//                icon: Icon(Icons.face,
//                    size: 22.0,
//                    color: _tabController.index == 0
//                        ? Colors.white
//                        : Colors.blue[900]),
//                child: Text(
//                  "Friends",
//                  style: TextStyle(
//                      fontSize: 16.0,
//                      color: _tabController.index == 0
//                          ? Colors.white
//                          : Colors.blue[900]),
//                ),
//              ),
//              Tab(
//                  icon: Icon(Icons.pie_chart,
//                      size: 22.0,
//                      color: _tabController.index == 1
//                          ? Colors.white
//                          : Colors.blue[900]),
//                  child: Text(
//                    "Polls",
//                    style: TextStyle(
//                        fontSize: 16.0,
//                        color: _tabController.index == 1
//                            ? Colors.white
//                            : Colors.blue[900]),
//                  )),
//            ],
//          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.lightGreen[900],
                      Colors.lightGreen[400],
                    ],
                  ),
                ),
                accountName: showUser
                    ? Text(
                        Username,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    : Text(
                        'Username',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                accountEmail: showEmail
                    ? Text(email,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                    : Text('email',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                currentAccountPicture: new CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/user.jpg'),
                ),
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  // _signOut(context)
                },
              ),
            ],
          ),
        ),
        body: //TabBarView(
//          controller: _tabController,
//          children: <Widget>[
            Home(),
            //PollSection(),
          //],
        ),
      //),
//      children: <Widget>[
//        FriendSection(),
//      ],
    );
  }
}

class Home extends StatefulWidget {
  Home({
    Key key,
    this.User,
    this.onSignedOut,
  }) : super(key: key);
  final User;
  final VoidCallback onSignedOut;
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String result, email, Username, status = '0';
  // String User;
  //HomeState(this.User);
  //final FirebaseAuth _auth =FirebaseAuth.instance;
  //final  _firestore=Firestore.instance;

  DocumentSnapshot snap;

  void getData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid.toString();
    print(uid);
    try {
      snap = await Firestore.instance.collection('Users').document(uid).get();
    } catch (e) {
      print('Hi');
    }
    setState(() {
      email = snap.data['Email'];
      Username = snap.data['Username'];
    });
    print(email);
    print(Username);
    // snapshot=await Firestore.instance.collection('Users').getDocuments();
    //print(UserId);
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  String receiver;
  String message;

  final CollectionReference collectionReference =
      Firestore.instance.collection('Users');
  crudMethods crudObj = new crudMethods();
  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'add data',
              style: TextStyle(fontSize: 15.0),
            ),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration:
                      InputDecoration(hintText: 'Enter the email of receiver'),
                  onChanged: (value) {
                    this.receiver = value;
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter the message for the receiver'),
                  onChanged: (value) {
                    this.message = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue[600],
                onPressed: () {
                  Navigator.of(context).pop();
                  Map<String, dynamic> chatData = {
                    'Receiver': this.receiver,
                    'Message': this.message,
                    'Sender': this.email,
                    'unRead': this.status,
                  };
                  crudObj.addData(chatData).then((result) {
                    dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Job done',
              style: TextStyle(fontSize: 15.0),
            ),
            content: Text('added'),
            actions: <Widget>[
              FlatButton(
                child: Text('Alright'),
                textColor: Colors.blue[600],
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

/*  final databaseReference = Firestore.instance;

  void getData() {
    databaseReference
        .collection("Users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data['Email']}}'));

    });
  }*/
  @override
  void initState() {
    getData();
    crudObj.getChat().then((results) {
      setState(() {
        snapShots = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          //CategorySelector(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 3.0,
              ),
              child: Container(
                margin: EdgeInsets.only(left: 5.0),
                height: 500,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45.0),
                    // topRight: Radius.circular(35.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 190, 1.0),
                        blurRadius: 18,
                        offset: Offset(0, 10))
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    // FavouriteContacts(),
                    //RecentChats(),
                    GroupChat(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GroupChat extends StatelessWidget {
  Widget build(BuildContext context) {
    if (snapShots != null) {
      return Expanded(
        child: Container(
            margin: EdgeInsets.only(left: 6.0),
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45.0),
                //topRight: Radius.circular(35.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45.0),
                //topRight: Radius.circular(35.0),
              ),
              child: StreamBuilder(
                  stream: snapShots,
                  builder: (context, snapShots) {
                    return ListView.builder(
                      itemCount: snapShots.data.documents.length,
                      padding: EdgeInsets.all(5.0),
                      itemBuilder: (context, i) {
                        if (snapShots.data.documents[i].data['id'] == uid) {
                          return Container();
                        } else {
                          return GestureDetector(
                            onTap: () {
                              // update = snapShots.data.documents[i].documentID;
                              //crudObj.updateData(update);
                              // Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(user: chat.sender),),),
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Chat(
                                            uid: uid,
                                            peerId: snapShots
                                                .data.documents[i].documentID,
                                            name: snapShots.data.documents[i]
                                                .data['Username'],
                                          )));
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 4.0, bottom: 7.0, right: 0.0, left: 0.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
//                                    snapShots.data.documents[i].data['Email'] ==
//                                            '0'
//                                        ? Colors.grey[100]
//                                        : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                            'assets/images/user.jpg'),
                                        backgroundColor: Colors.blueGrey,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapShots.data.documents[i]
                                                .data['Username'],
                                            style: TextStyle(
                                              color: Colors.grey[900],
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            child: Text(
                                              snapShots.data.documents[i]
                                                  .data['Email'],
                                              style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      snapShots.data.documents[i]
                                                  .data['Email'] ==
                                              '0'
                                          ? Container(
                                              width: 40,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'NEW',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : Text(''),
                                      SizedBox(
                                        height: 18.0,
                                      ),
                                      Text(
                                        //chat.time,
                                        '',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        ;
                      },
                    );
                  }),
            )),
      );
    } else {
      return Text(
        'Loading',
      );
    }
  }
}

enum SingingCharacter { Yes, No }

class PollSection extends StatefulWidget {
  @override
  _PollSectionState createState() => _PollSectionState();
}

class _PollSectionState extends State<PollSection> {
  SingingCharacter _character = SingingCharacter.Yes;
  bool showGraph =false;
  void initState() {
    crudObj.getPolls().then((results) {
      setState(() {
        snapsnap = results;
      });
    });
    super.initState();
    dataMap.putIfAbsent("YES", () => 1);
    dataMap.putIfAbsent("NO", () => 2);
  }

  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.green,
    Colors.red,
  ];
  String pollQues;
  int _radioValue1 = -1;
  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          // Fluttertoast.showToast(msg: 'Correct !',toastLength: Toast.LENGTH_SHORT);
          //correctScore++;
          break;
        case 1:
          // Fluttertoast.showToast(msg: 'Try again !',toastLength: Toast.LENGTH_SHORT);
          break;
        case 2:
          // Fluttertoast.showToast(msg: 'Try again !',toastLength: Toast.LENGTH_SHORT);
          break;
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          //CategorySelector(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 3.0,
              ),
              child: Container(
                margin: EdgeInsets.only(right: 5.0),
                height: 500,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    //topLeft: Radius.circular(45.0),
                    topRight: Radius.circular(45.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 190, 1.0),
                        blurRadius: 18,
                        offset: Offset(0, 10))
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 6.0),
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(45.0),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(45.0),
                          ),
                          child: Stack(
                            children: <Widget>[
                              StreamBuilder(
                                stream: snapsnap,
                                builder: (context, snapsnap) {
                                  return ListView.builder(
                                    itemCount: snapsnap.data.documents.length,
                                    padding: EdgeInsets.all(5.0),
                                    itemBuilder: (context, i) {
                                      if (snapsnap.hasError) {
                                        return Text('Error: ${snapsnap.error}');
                                      } else {
                                        return GestureDetector(
                                          onTap: () {
//                                              // update = snapShots.data.documents[i].documentID;
//                                              //crudObj.updateData(update);
//                                              // Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(user: chat.sender),),),
//                                              Navigator.push(
//                                                  context,
//                                                  MaterialPageRoute(
//                                                      builder: (context) =>
//                                                          Chat(
//                                                            uid: uid,
//                                                            peerId: snapShots
//                                                                .data
//                                                                .documents[i]
//                                                                .documentID,
//                                                            name: snapShots.data
//                                                                .documents[i]
//                                                                .data['Username'],
//                                                          )));
                                          },
                                          child: showGraph ?Container(
                                            margin: EdgeInsets.only(
                                                top: 4.0,
                                                bottom: 7.0,
                                                right: 0.0,
                                                left: 0.0),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20.0),
                                                bottomRight:
                                                Radius.circular(20.0),
                                                topLeft: Radius.circular(20.0),
                                                bottomLeft:
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Text(
                                                        snapsnap
                                                            .data
                                                            .documents[i]
                                                            .data['ques'],
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey[900],
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width *
                                                            0.45,
                                                        child: Text(
                                                          '-' +
                                                              snapsnap
                                                                  .data
                                                                  .documents[
                                                              i]
                                                                  .data['createdBy'],
                                                          style:
                                                          TextStyle(
                                                            color: Colors
                                                                .blueGrey,
                                                            fontSize:
                                                            10.0,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                          ),
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                ],
                                              ),],
                                            ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    PieChart(
                                                      dataMap: dataMap,
                                                      animationDuration: Duration(milliseconds: 800),
                                                      chartLegendSpacing: 32.0,
                                                      chartRadius: MediaQuery.of(context).size.width / 2.7,
                                                      showChartValuesInPercentage: true,
                                                      showChartValues: true,
                                                      showChartValuesOutside: false,
                                                      chartValueBackgroundColor: Colors.grey[200],
                                                      colorList: colorList,
                                                      showLegends: true,
                                                      legendPosition: LegendPosition.right,
                                                      decimalPlaces: 1,
                                                      showChartValueLabel: true,
                                                      initialAngle: 0,
                                                      chartValueStyle: defaultChartValueStyle.copyWith(
                                                        color: Colors.blueGrey[900].withOpacity(0.9),
                                                      ),
                                                      chartType: ChartType.disc,
                                                    ),

                                                  ],
                                                )
                                            ],
                                          ),
                                          ):Container(
                                            margin: EdgeInsets.only(
                                                top: 4.0,
                                                bottom: 7.0,
                                                right: 0.0,
                                                left: 0.0),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20.0),
                                                bottomRight:
                                                    Radius.circular(20.0),
                                                topLeft: Radius.circular(20.0),
                                                bottomLeft:
                                                    Radius.circular(20.0),
                                              ),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              snapsnap
                                                                  .data
                                                                  .documents[i]
                                                                  .data['ques'],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey[900],
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.45,
                                                              child: Text(
                                                                '-' +
                                                                    snapsnap
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .data['createdBy'],
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blueGrey,
                                                                  fontSize:
                                                                      10.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: <Widget>[
                                                        snapsnap
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .data[
                                                                    'pollActive'] ==
                                                                'Yes'
                                                            ? Container(
                                                                width: 40,
                                                                height: 20,
                                                                margin: EdgeInsets.all(3.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30.0),
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  'ACTIVE',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              )
                                                            : Text(''),
                                                        SizedBox(
                                                          height: 18.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Radio(
                                                      value: 0,
                                                      groupValue: _radioValue1,
                                                      onChanged:
                                                          _handleRadioValueChange1,
                                                    ),
                                                    new Text(
                                                      'YES',
                                                      style: new TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    new Radio(
                                                      value: 1,
                                                      groupValue: _radioValue1,
                                                      onChanged:
                                                          _handleRadioValueChange1,
                                                    ),
                                                    new Text(
                                                      'NO',
                                                      style: new TextStyle(
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          snapsnap.data.documents[i]
                                                              .data['id'] ==
                                                              'hi'
                                                              ? Container(
                                                            margin: EdgeInsets.all(3.0),
                                                            decoration:
                                                            BoxDecoration(
                                                              color: Colors
                                                                  .lightBlue[50],
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  30.0),
                                                            ),
                                                            child:
                                                            FlatButton(
                                                              splashColor: Colors.green,
                                                              child:
                                                              Text(
                                                                "Submit",
                                                                style:
                                                                TextStyle(color: Colors.blueGrey),
                                                              ),
                                                              onPressed:
                                                                  () {
                                                                setState(() {
                                                                  showGraph=true;
                                                                });
                                                                  },
                                                            ),
                                                          )
                                                              : Text(''),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top:430.0,left: 16,right: 16.0,bottom: 16.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Column(
                                      children: <Widget>[
                                        FloatingActionButton(
                                          heroTag: null,
                                          onPressed: () {
                                            //  lat = _lastMapPosition.latitude;
                                            // long = _lastMapPosition.longitude;
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (builder) {
                                                return Container(
                                                  height: 170.0,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        "Send a Poll ? ",
                                                        style: TextStyle(fontSize: 20.0),
                                                      ),
                                                      SizedBox(
                                                        height: 12.0,
                                                      ),
                                                      TextField(
                                                        decoration: InputDecoration(
                                                            hintText:
                                                            'Ask a question '),
                                                        onChanged: (value) {
                                                          this.pollQues = value;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: <Widget>[
                                                              FlatButton(
                                                              child: Text('Add'),
                                                              textColor: Colors.white,
                                                              color: Colors.blueGrey[900],
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              }),
                                                            ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          materialTapTargetSize: MaterialTapTargetSize.padded,
                                          backgroundColor: Colors.blue,
                                          child: Icon(
                                            Icons.add,
                                            size: 36.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16.0,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
