import 'package:flutter/material.dart';
import 'blog/blog.dart';
import 'detailedBlogView.dart'; // Import the Blog class

class FavoritesList extends StatefulWidget {
  final List<Blog> favoritesblogs;
  final Function(Blog) toggleFavorite;
  FavoritesList({
    required this.favoritesblogs,
    required this.toggleFavorite,
  });

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

//
class _FavoritesListState extends State<FavoritesList> {
  @override
  Widget build(BuildContext context) {
    if (widget.favoritesblogs.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Blog Explorer'),
        ),
        body: Center(
          child: Text('No favorite blogs yet.'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Blog Explorer'),
        ),
        body: ListView.builder(
          itemCount: widget.favoritesblogs.length,
          itemBuilder: (context, index) {
            final blog = widget.favoritesblogs[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailedBlogView(blog: blog),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.network(
                          blog.imageUrl,
                          width: double.infinity,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        IconButton(
                          icon: blog.isFavorite
                              ? Icon(
                                  Icons.star,
                                  color: Color.fromARGB(255, 247, 222, 2),
                                )
                              : Icon(Icons.star_border),
                          onPressed: () {
                            // Call the toggleFavorite function and update the blog's isFavorite
                            widget.toggleFavorite(blog);
                            setState(() {
                              blog.isFavorite = !blog.isFavorite;
                            });
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        blog.title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
