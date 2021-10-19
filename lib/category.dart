import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late List data;

  // Function to get the JSON data
  Future<String> getJSONData() async {
    var response = await http.get(
      // Encode the url
        Uri.parse("https://unsplash.com/napi/photos/Q14J2k8VE3U/related"),
        // Only accept JSON response
        headers: {"Accept": "application/json"}
    );

    setState(() {
      // Get the JSON data
      data = json.decode(response.body)['results'];
    });

    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildListView(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Name"),
      ),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (context, index) {
          return _buildImageColumn(data[index]);
          // return _buildRow(data[index]);
        }
    );
  }

  Widget _buildImageColumn(dynamic item) => Container(
    decoration: BoxDecoration(
        color: Colors.white54
    ),
    margin: const EdgeInsets.all(4),
    child: Column(
      children: [
        new CachedNetworkImage(
          imageUrl: item['urls']['small'],
          placeholder: (context, url) => new CircularProgressIndicator(),
          errorWidget: (context, url, error) => new Icon(Icons.error),
          fadeOutDuration: new Duration(seconds: 1),
          fadeInDuration: new Duration(seconds: 3),
        ),
        _buildRow(item)
      ],
    ),
  );

  Widget _buildRow(dynamic item) {
    return ListTile(
      title: Text(
        item['description'] == null ? '': item['description'],
      ),
      subtitle: Text("Likes: " + item['likes'].toString()),
    );
  }
  @override
  void initState() {
    super.initState();
    // Call the getJSONData() method when the app initializes
    this.getJSONData();
  }
}