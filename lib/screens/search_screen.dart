import 'package:chat_app/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();

  // QuerySnapshot<Map<String, dynamic>>? searchSnapShot;
  // late QuerySnapshot<Map<String, dynamic>> searchSnapShot;

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

  /*Widget search() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Not Exist Documents'),
          );
        }
        if (snapshot.hasData) {
          print('snapshot : $snapshot');
          print('snapshot.data : ${snapshot.data}');
          // print('snapshot.data.docs : ${snapshot.data.docs}');
          final temp = snapshot.data;
          print(temp!.docs[0].data());

          return ListView(
            children: temp.docs.map(
              (doc) {
                Map map = doc.data() as Map;
                return SearchTile(
                    userName: map['username'], userEmail: map['email']);
              },
            ).toList(),
          );
        } //
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }*/

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

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;

  SearchTile({
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
