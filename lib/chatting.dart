import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_page/const.dart';
import 'package:intl/intl.dart';
import 'dart:math';

int index;
var keys = [0,0];

void key_generate(grp) {
  var key_id = grp;
  print(key_id);
  var temp = key_id;
  bool flag = false;
  print("ORignial keys ${keys[0]}");
  print(keys);
  var sum = 0;
  while (key_id != 0) {
    var a = key_id % 10;
    if (a.gcd(26) == 1 && a != 0) {
      print("Working");
      print(a);
      keys[0] = a;
      print(" KEYs[0] ${keys[0]}");
      break;
    }
    key_id = (key_id / 10).toInt();

    print("trial look");
    print(" KEYs[0] ${keys[0]}");
    print(" KEYs[1] ${keys[1]}");
  }
  while (temp !=0)
  {
    var b = temp % 10;
    sum = sum + b;
    temp = (temp/10).toInt();
  }
  keys[1]=sum;
  print(" KEYs[1] ${keys[1]}");
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

class Chat extends StatelessWidget {
  final String peerId;
  final String name;
  final String uid;

  Chat(
      {Key key, @required this.peerId, @required this.name, @required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue[600],
        title: new Text(
          name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: new ChatScreen(
        uid: uid,
        peerId: peerId,
        name: name,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String name;
  final String uid;

  ChatScreen(
      {Key key, @required this.peerId, @required this.name, @required this.uid})
      : super(key: key);

  @override
  State createState() =>
      new ChatScreenState(peerId: peerId, name: name, uid: uid);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState(
      {Key key,
        @required this.peerId,
        @required this.name,
        @required this.uid});
  String peerId;
  String name;
  String uid;
  var listMessage;
  String groupChatId;
  SharedPreferences prefs;

  bool isLoading;

  final TextEditingController textEditingController =
  new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    groupChatId = '';
    readLocal();
  }

  readLocal() async {
    //prefs = await SharedPreferences.getInstance();
    // print(prefs);
    print('udit');
    print(uid);
    print(uid.hashCode);
    print(peerId.hashCode);
    print('$uid-$peerId');
    //id = prefs.getString('id') ?? '';
    if (uid.hashCode <= peerId.hashCode) {
      groupChatId = '$uid-$peerId';
    } else {
      groupChatId = '$peerId-$uid';
    }
    key_generate(groupChatId.hashCode);

    print(groupChatId.hashCode);
    print("IDDDDDD");
    print(groupChatId[0]);
    print(groupChatId);
    Firestore.instance
        .collection('Users')
        .document(uid)
        .updateData({'chattingWith': peerId});

    setState(() {});
  }

  void onSendMessage(String content, int type) {
    // print('udit');
    // print('bdvbbvvb');
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      var cipher = encrypt(content);

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': uid,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': cipher,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Text('Nothing to send');
    }
  }

//  Widget buildItem(int type, DocumentSnapshot document) {
//    if (document['idFrom'] == uid) {
//      // Right (my message)
//      print("type is ");
//      print(type);
//      return Row(
//        children: <Widget>[
//          document['type'] == 0
//              // Text
//              ? Container(
//                  child: Text(
//                    document['content'],
//                    style: TextStyle(color: primaryColor),
//                  ),
//                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
//                  width: 200.0,
//                  decoration: BoxDecoration(
//                      color: greyColor2,
//                      borderRadius: BorderRadius.circular(8.0)),
//                  margin: EdgeInsets.only(
//                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
//                      right: 10.0),
//                )
//              : document['type'] == 1
//                  // Image
//                  ? Container(
//                      child: FlatButton(
//                        child: Material(),
//                        padding: EdgeInsets.all(0),
//                        onPressed: () {},
//                      ),
//                      margin: EdgeInsets.only(
//                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
//                          right: 10.0),
//                    )
//                  // Sticker
//                  : Container(
//                      child: new Image.asset(
//                        'images/${document['content']}.gif',
//                        width: 100.0,
//                        height: 100.0,
//                        fit: BoxFit.cover,
//                      ),
//                      margin: EdgeInsets.only(
//                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
//                          right: 10.0),
//                    ),
//        ],
//        mainAxisAlignment: MainAxisAlignment.end,
//      );
//    } else {
//      // Left (peer message)
//      return Container(
//        child: Column(
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                isLastMessageLeft(index) ? Material() : Container(width: 35.0),
//                document['type'] == 0
//                    ? Container(
//                        child: Text(
//                          document['content'],
//                          style: TextStyle(color: Colors.white),
//                        ),
//                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
//                        width: 200.0,
//                        decoration: BoxDecoration(
//                            color: primaryColor,
//                            borderRadius: BorderRadius.circular(8.0)),
//                        margin: EdgeInsets.only(left: 10.0),
//                      )
//                    : document['type'] == 1
//                        ? Container(
//                            child: FlatButton(
//                              child: Material(),
//                              padding: EdgeInsets.all(0),
//                              onPressed: () {},
//                            ),
//                            margin: EdgeInsets.only(left: 10.0),
//                          )
//                        : Container(
//                            child: new Image.asset(
//                              'images/${document['content']}.gif',
//                              width: 100.0,
//                              height: 100.0,
//                              fit: BoxFit.cover,
//                            ),
//                            margin: EdgeInsets.only(
//                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
//                                right: 10.0),
//                          ),
//              ],
//            ),
//
//            // Time
//            isLastMessageLeft(index)
//                ? Container(
//                    child: Text(
//                      DateFormat('dd MMM kk:mm').format(
//                          DateTime.fromMillisecondsSinceEpoch(
//                              int.parse(document['timestamp']))),
//                      style: TextStyle(
//                          color: greyColor,
//                          fontSize: 12.0,
//                          fontStyle: FontStyle.italic),
//                    ),
//                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
//                  )
//                : Container()
//          ],
//          crossAxisAlignment: CrossAxisAlignment.start,
//        ),
//        margin: EdgeInsets.only(bottom: 10.0),
//      );
//    }
//  }
//
//  bool isLastMessageLeft(int index) {
//    if ((index > 0 &&
//            listMessage != null &&
//            listMessage[index - 1]['idFrom'] == uid) ||
//        index == 0) {
//      return true;
//    } else {
//      return false;
//    }
//  }
//
//  bool isLastMessageRight(int index) {
//    if ((index > 0 &&
//            listMessage != null &&
//            listMessage[index - 1]['idFrom'] != uid) ||
//        index == 0) {
//      return true;
//    } else {
//      return false;
//    }
//  }

  Future<bool> onBackPress() {
    Firestore.instance
        .collection('Users')
        .document(uid)
        .updateData({'chattingWith': null});
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Sticker
              (Container()),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          //  buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  /*Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
        ),
        color: Colors.white.withOpacity(0.8),
      )
          : Container(),
    );
  }*/
  Widget buildInput() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
      child: Row(
        children: <Widget>[
          // Button send image
          // Edit text
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
              child: TextField(
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                // focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(
                  Icons.send,
                  color: Colors.green[900],
                ),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.grey[300],
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
          new Border(top: new BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('messages')
            .document(groupChatId)
            .collection(groupChatId)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(themeColor)));
          } else {
            List<DocumentSnapshot> docs = snapshot.data.documents;
            List<Widget> messages = docs
                .map((doc) => Message(
              from: doc.data['idFrom'],
              text: doc.data['content'],
              me: uid == doc.data['idFrom'],
              time: doc.data['timestamp'],
            ))
                .toList();
            return ListView(
              reverse: true,
              controller: listScrollController,
              children: <Widget>[
                ...messages,
              ],
            );
            //listMessage = snapshot.data.documents;
//            return ListView.builder(
//              padding: EdgeInsets.all(10.0),
//              itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
//              itemCount: snapshot.data.documents.length,
//              reverse: true,
//             controller: listScrollController,
//            );
          }
        },
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final bool me;
  final String time;

  const Message({Key key, this.from, this.text, this.me, this.time})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (text.isNotEmpty) {
      print(me);
      print(text);
      var plain = decrypt(text);
      print(from);
      return Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
        padding: EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
        child: Column(
          crossAxisAlignment:
          me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              DateFormat('dd MMM kk:mm')
                  .format(DateTime.fromMillisecondsSinceEpoch(int.parse(time))),
              style: TextStyle(fontSize: 10.0),
            ),
            Material(
              color: me ? Colors.greenAccent : Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
              elevation: 6.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  plain,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}

String encrypt(String content) {
  var ab = content;
  var a = ab.split('');
  var cnt = 0;
  var cipher = "";
  for (var char in a) {
    if (char == ' ')
      cipher = cipher + char;
    else if (char == "@") {
      char = "!";
      cipher = cipher + char;
    } else if (char == "%") {
      char = "#";
      cipher = cipher + char;
    } else if (char == "!") {
      char = "\$";
      cipher = cipher + char;
    } else if (char == "\$") {
      char = "@";
      cipher = cipher + char;
    } else if (char == "#") {
      char = "&";
      cipher = cipher + char;
    } else if (char == "&") {
      char = "%";
      cipher = cipher + char;
    } else if (isNumeric(char)) {
      if (char == "1") {
        char = "5";
        cipher = cipher + char;
      } else if (char == "2") {
        char = "7";
        cipher = cipher + char;
      } else if (char == "3") {
        char = "4";
        cipher = cipher + char;
      } else if (char == "4") {
        char = "9";
        cipher = cipher + char;
      } else if (char == "5") {
        char = "2";
        cipher = cipher + char;
      } else if (char == "6") {
        char = "8";
        cipher = cipher + char;
      } else if (char == "7") {
        char = "0";
        cipher = cipher + char;
      } else if (char == "8") {
        char = "3";
        cipher = cipher + char;
      } else if (char == "9") {
        char = "6";
        cipher = cipher + char;
      } else if (char == "0") {
        char = "1";
        cipher = cipher + char;
      }
    } else if (char.toUpperCase() == char) {
      var a = char.codeUnits;
      cipher = cipher +
          String.fromCharCode((keys[0] * a[cnt] + keys[1] - 65) % 26 + 65);
      print(String.fromCharCode((keys[0] * a[cnt] + keys[1] - 65) % 26 + 65));
      // print(cipher);
    } else if (char.toLowerCase() == char) {
      var a = char.toUpperCase().codeUnits;
      var temp =
      String.fromCharCode((keys[0] * a[cnt] + keys[1] - 65) % 26 + 65);

      cipher = cipher + temp.toLowerCase();
      print(String.fromCharCode((keys[0] * a[cnt] + keys[1] - 65) % 26 + 65));
      // print(cipher);
    }
  }
  print(cipher);
  return cipher;
}

String decrypt(String content) {
  var ab = content;
  var a = ab.split('');
  var cnt = 0;
  var plain = "";
  for (var char in a) {
    if (char == ' ')
      plain = plain + char;
    else if (char == "@") {
      char = "\$";
      plain = plain + char;
    } else if (char == "%") {
      char = "&";
      plain = plain + char;
    } else if (char == "!") {
      char = "@";
      plain = plain + char;
    } else if (char == "\$") {
      char = "!";
      plain = plain + char;
    } else if (char == "#") {
      char = "%";
      plain = plain + char;
    } else if (char == "&") {
      char = "#";
      plain = plain + char;
    } else if (isNumeric(char)) {
      if (char == "1") {
        char = "0";
        plain = plain + char;
      } else if (char == "2") {
        char = "5";
        plain = plain + char;
      } else if (char == "3") {
        char = "8";
        plain = plain + char;
      } else if (char == "4") {
        char = "3";
        plain = plain + char;
      } else if (char == "5") {
        char = "1";
        plain = plain + char;
      } else if (char == "6") {
        char = "9";
        plain = plain + char;
      } else if (char == "7") {
        char = "2";
        plain = plain + char;
      } else if (char == "8") {
        char = "6";
        plain = plain + char;
      } else if (char == "9") {
        char = "4";
        plain = plain + char;
      } else if (char == "0") {
        char = "7";
        plain = plain + char;
      }
    } else if (char.toUpperCase() == char) {
      var a = char.codeUnits;
      plain = plain +
          String.fromCharCode(
              modinv(keys[0], 26) * (a[cnt] - keys[1] - 65) % 26 + 65);
      // print(String.fromCharCode(15 *( a[cnt] - key[1] - 65) % 26 + 65));

      //     String.fromCharCode(modinv(key[0],26) * (a[cnt] - key[1] - 65) % 26 + 65);
      // print(String.fromCharCode(modinv(key[0],26) *( a[cnt] - key[1] - 65) % 26 + 65));

      // print(plain);
    } else if (char.toLowerCase() == char) {
      var a = char.toUpperCase().codeUnits;

      var temp = String.fromCharCode(
          modinv(keys[0], 26) * (a[cnt] - keys[1] - 65) % 26 + 65);

      plain = plain + temp.toLowerCase();
      // print(String.fromCharCode(modinv(key[0],26) * (a[cnt] - key[1] - 65) % 26 + 65));
      // print(plain);
    }
  }
  print(plain);
  return plain;
}

List egcd(int a, int b) {
  var x = 0;
  var y = 1;
  var u = 1;
  var v = 0;

  while (a != 0) {
    var q = (b / a).toInt();
    var r = b % a;
    var m = x - u * q;
    var n = y - v * q;

    b = a;
    a = r;
    x = u;
    y = v;
    u = m;
    v = n;
  }
  var gcd = b;

  var value = [gcd, x, y];
  return value;
}

int modinv(a, m) {
  var value = egcd(a, m);
  if (value[0] != 1) {
    print("Modular Inverse not possible");
  } else {
    return value[1] % m;
  }
}