import 'package:flutter/material.dart';
//import 'package:Shrine/colors.dart';
//TODO: try using search delegate option
class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => new _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Widget appBarTitle = new Text("Know just what you need?");
  Icon icon = new Icon(
    Icons.search,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchcontroller = new TextEditingController();
  List<dynamic> _list;
  bool _isSearching;
  String _searchText;
  List searchresult = new List();

  _SearchBarState() {
    _searchcontroller.addListener(() {
      if (_searchcontroller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = null;
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchcontroller.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    values();
  }

  void values() {
    _list = List();
    _list.add("Milk");
    _list.add("Bread");
    _list.add("Orange");
    _list.add("Apple");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        appBar: buildAppBar(context),
        body: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Flexible(
                  child: searchresult.length != 0 || _searchcontroller.text.isNotEmpty
                      ? new ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchresult.length,
                    itemBuilder: (BuildContext context, int index) {
                      String listData = searchresult[index];
                      return new ListTile(
                        title: new Text(listData.toString()),
                      );
                    },
                  )
                      : new ListView.builder(
                    shrinkWrap: true,
                    itemCount: _list.length,
                    itemBuilder: (BuildContext context, int index) {
                      String listData = _list[index];
                      return new ListTile(
                        title: new Text(listData.toString()),
                      );
                    },
                  ))
            ],
          ),
        ));
  }

  Widget buildAppBar(BuildContext context) {
    //TODO: Change this crappy looking appbar, make it look like the Login Page ones
    //TODO : Make the search easier, increase the touch area, simply the search button
    //TODO: isn't enough for smooth searching
    //TODO: Compare with Flutter's native search bar implementation
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.black,
              );
              this.appBarTitle = new TextField(
                controller: _searchcontroller,
                style: new TextStyle(
                  color: Colors.black,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.black),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.black)),
                onChanged: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.black,
      );
      this.appBarTitle = new Text(
        "Search",
        style: new TextStyle(color: Colors.black),
      );
      _isSearching = false;
      _searchcontroller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  }
}