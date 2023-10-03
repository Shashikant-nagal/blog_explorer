import 'package:blog_explorer/favorites_list.dart';
import 'package:flutter/material.dart';
import 'blog/blogList.dart';
import 'blog/blog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Blog> favorites = [];

  void toggleFavorite(Blog blog) {
    setState(() {
      if (favorites.contains(blog)) {
        favorites.remove(blog);
      } else {
        favorites.add(blog);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Explorer'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FavoritesList(
                    favoritesblogs: favorites,
                    toggleFavorite: toggleFavorite,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlogList(
        favorites: favorites,
        toggleFavorite: toggleFavorite,
      ),
    );
  }
}
