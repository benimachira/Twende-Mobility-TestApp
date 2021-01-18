import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'database_helper.dart';

class Repository extends StatefulWidget {
  _RepositoryState createState() => _RepositoryState();
}

class _RepositoryState extends State<Repository> {
  List<Repositories> sub_categories;
  final dbHelper = DatabaseHelper.instance;

  Future<List<Repositories>> _get_sub_categories() async {
    var request_url =
        'https://api.github.com/users/benimachira/repos?per_page=10';

    http.Response http_respose = await http.get(request_url);
    var response_data = jsonDecode(http_respose.body);

    List<Repositories> sub = (response_data as List)
        .map((item) => Repositories.fromJson(item))
        .toList();

    return sub;

//    SubCategories subCategory = SubCategories.fromJson(response_data);
//    sub_categories.add(subCategory);
//    print(subCategory);
  }

  Future<bool> _existsprefs(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool is_there = prefs.containsKey(value);
    return is_there;
  }

  void _add_remove(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkValue = prefs.containsKey(value);
    if (checkValue) {
      prefs.remove(value);
    } else {
      prefs.setInt(value, 1);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositories'),
      ),
      body: Container(
        child: Container(
          child: FutureBuilder(
            future: _get_sub_categories(),
            builder: (context, snapshot) {
//                        print(snapshot.data);
              if (snapshot.hasData) {
//                    SubCategories subcategory = SubCategories.fromJson(snapshot.data);
                List<Repositories> subcat = snapshot.data;

                return ListView.builder(
                  itemCount: subcat.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    String descrip = subcat[index].description;
                    return Container(
                      padding: EdgeInsets.only(top: 24, right: 8, left: 8),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            child: Image.asset(
                              'assets/git.png',
                              height: 20,
                            ),
                            padding: EdgeInsets.all(4),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      subcat[index].name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${descrip}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700]),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(children: [
                                        Expanded(
                                          child: Text(
                                            'Forks ${subcat[index].forks}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[500]),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Watchers ${subcat[index].watchers}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[500]),
                                          ),
                                        ),
                                      ],),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          // Container(
                          //   child: InkWell(
                          //       onTap: () {
                          //         _insert(subcat[index].id,1);
                          //       },
                          //       child: Icon(Icons.bookmark_border)),
                          // ),
                          Container(
                            child: FutureBuilder(
                              future: _query_bookmarks(subcat[index].id),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List my_list = snapshot.data;

                                  if (my_list.isNotEmpty) {
                                    return InkWell(
                                      onTap: () {
                                        _delete(subcat[index].id);
                                      },
                                      child: Icon(
                                        Icons.bookmark,
                                        size: 20,
                                      ),
                                    );
                                  } else {
                                    return InkWell(
                                      onTap: () {
                                       _insert(subcat[index].id,1);
                                      },
                                      child: Icon(
                                        Icons.bookmark_border,
                                        size: 20,
                                      ),
                                    );
                                  }
                                  print('FGGG ${snapshot.data}');
                                }  else {
                                  return InkWell(
                                    onTap: () {
                                      _add_remove('L_${subcat[index].id}');
                                    },
                                    child: Icon(
                                      Icons.bookmark_border,
                                      size: 20,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    );
                  },
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
            },
          ),
        ),
      ),
    );
  }

  void _insert(int column_id, int status) async {
    // row to insert
    Map<String, dynamic> row_data = {
      DatabaseHelper.bookmarks_columnId: column_id,
      DatabaseHelper.bookmarks_status: status
    };
    final id = await dbHelper.insert(row_data);
    print('inserted row id: $id');

    setState(() {

    });
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  _query_bookmarks(int bookmark_id) async {
    final allRows = await dbHelper.query_bookmarks(bookmark_id);
    print('query all rows:');
    allRows.forEach((row) => print(row));
    return allRows;
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {DatabaseHelper.bookmarks_columnId: 1};
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
    setState(() {

    });
  }


}

class Repositories {
  final int id;
  final String name;
  final String description;
  final int forks;
  final int watchers;

  Repositories(
      {this.id, this.name, this.description, this.forks, this.watchers});

  Repositories.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        forks = json['forks'],
        watchers = json['watchers'];

  @override
  String toString() {
    return 'Repositories{id: $id, name: $name, description: $description, forks: $forks, watchers: $watchers}';
  }
}
