import 'package:chat_app/constants.dart';
import 'package:chat_app/constants_function.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();

  dynamic searchSnapShot;

  bool isShowSearchList = false;

  initiateSearch() {
    String searchText = searchTextEditingController.text;
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((value) {
      print('value : $value');
      print('value.docs[0].data() : ${value.docs[0].data()}');
      //todo : get reRendered ui
      setState(() {
        searchSnapShot = value;
        isShowSearchList = true;
      });
    }).catchError((e) {
      print(e.toString());
      /*Fluttertoast.showToast(
          msg: 'No username or please enter a valid username');
      Fluttertoast.showToast(msg: e.toString());*/
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: const Text('No username or please enter a valid username'),
        ),
      );
      setState(() {
        isShowSearchList = false;
      });
    });
  }

  Widget searchList() {
    return searchSnapShot != null
        ? Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: searchSnapShot!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                //data()===>>>field document===>>Map<String,dynamic> field
                Map map = searchSnapShot!.docs[index].data();
                return SearchTile(
                  userName: map['username'],
                  userEmail: map['email'],
                );
              },
            ),
          )
        : const Center(
            child: Text('Not Exist Documents'),
          );
  }

  createChatRoomAndStartConversation({required String userName}) async {
    if (userName != kMyName) {
      String chatRoomId = getChatRoomId(userName, kMyName);
      List<String> users = [userName, kMyName];
      Map<String, dynamic> chatRoomMap = {
        'chatroomId': chatRoomId,
        'users': users,
      };
      databaseMethods.createChatRoom(
          chatRoomId: chatRoomId, charRoomMap: chatRoomMap);
      kNavigator(context, 'conversation', chatRoomId);
    } //
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: const Text('you can\'t send message to yourself'),
        ),
      );
      return;
    }
  }

  Widget SearchTile({required String userName, required String userEmail}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: kTxtStyleSearchResult,
              ),
              Text(
                userEmail,
                style: kTxtStyleSearchResult,
              ),
            ],
          ),
          const Spacer(),
          ActionChip(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            backgroundColor: Colors.blue,
            label: const Text(
              'Message',
              style: kTxtStyleSearchResult,
            ),
            onPressed: () {
              createChatRoomAndStartConversation(userName: userName);
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        color: kBackgroundColorDecoration,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration:
                          kTextFieldInputDecoration('Search Username...')
                              .copyWith(
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (value == "") {
                          setState(() {
                            isShowSearchList = false;
                          });
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Image.asset(
                        'assets/images/search_1.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isShowSearchList,
              child: searchList(),
            ),
          ],
        ),
      ),
    );
  }
}

//todo ===>> generate unique id
String getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } //
  else {
    return "$a\_$b";
  }
}
