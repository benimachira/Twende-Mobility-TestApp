import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twende_mobility_test_app/repository_screen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


class MyHome extends StatefulWidget {
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Future<Account> _get_sub_categories() async {
    var request_url =
        'https://api.github.com/users/benimachira';

    http.Response http_respose = await http.get(request_url);
    var response_data = jsonDecode(http_respose.body);

    // List<Account> sub = (response_data as List)
    //     .map((item) => Account.fromJson(item))
    //     .toList();

    Account account= Account.fromJson(response_data);

    return account;

//    SubCategories subCategory = SubCategories.fromJson(response_data);
//    sub_categories.add(subCategory);
//    print(subCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text(
          'My Github',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        actions: [Icon(Icons.notifications_active)],
      ),
      body: FutureBuilder(
          future: _get_sub_categories(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Account account = snapshot.data;
              print(account);
              return Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.only(left: 16),
                            child: Center(
                              child: Image.network(
                                account.avatar_url,
                                height: 70,
                                width: 70,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          flex: 8,
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      account.name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      account.bio,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 88,
                      margin: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Center(
                        child: Table(
                          border: TableBorder.symmetric(
                            inside: BorderSide(
                              width: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                          children: [
                            TableRow(children: [
                              Container(
                                height: 80,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Followers',
                                        textAlign: TextAlign.center),
                                    Text(
                                      '${account.followers}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 80,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Following',
                                        textAlign: TextAlign.center),
                                    Text(
                                      '${account.following}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 80,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Repositories', textAlign: TextAlign.center),
                                    Text(
                                      '${account.public_repos}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Repository(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/git.png',
                                  height: 24,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Container(
                                    child: Text(
                                      'Repositories',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          InkWell(
                            onTap: () {
                              _create_message();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.bookmark_border),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Container(
                                    child: Container(
                                      child: Text(
                                        'My projects',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          InkWell(
                            onTap: () {
                              _create_message();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Container(
                                    child: Container(
                                      child: Text(
                                        'Edit profile',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          InkWell(
                            onTap: () {
                              _create_message();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.share),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Container(
                                    child: Container(
                                      child: Text(
                                        'Share my profile',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: Text('Error Occurred'),
              );
            } else {
              return Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
  _create_message(){
    Fluttertoast.showToast(
        msg: "Feature coming soon",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


}

class Account {
  final String name;
  final String avatar_url;
  final String bio;
  final int public_repos;
  final int followers;
  final int following;

  Account(
      {this.name,
      this.avatar_url,
      this.bio,
      this.public_repos,
      this.followers,
      this.following});

  Account.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        avatar_url = json['avatar_url'],
        bio = json['bio'],
        public_repos = json['public_repos'],
        followers = json['followers'],
        following = json['following'];

  @override
  String toString() {
    return 'Account{name: $name, avatar_url: $avatar_url, bio: $bio, public_repos: $public_repos, followers: $followers, following: $following}';
  }
}
