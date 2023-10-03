import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../detailedBlogView.dart';
import 'blog.dart'; // Import the Blog class

class BlogList extends StatefulWidget {
  final List<Blog> favorites;
  final Function(Blog) toggleFavorite;
  BlogList({
    required this.favorites,
    required this.toggleFavorite,
  });

  @override
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  List<Blog> blogs = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    final String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        // Request successful, parse the response and update the state
        final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> blogData = data['blogs'];

        setState(() {
          blogs = blogData.map((data) {
            final blog = Blog.fromJson(data);
            // Check if this blog is in favorites
            blog.isFavorite = widget.favorites.contains(blog);
            return blog;
          }).toList();
          isLoading = false; // Set loading to false
        });
      } else {
        // Request failed
        print('Request failed with status code: ${response.statusCode}');
        setState(() {
          isError = true; // Set isError to true
          isLoading = false; // Set loading to false
        });
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      print('Error: $e');
      setState(() {
        isError = true; // Set isError to true
        isLoading = false; // Set loading to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isLoading)
          Center(
            child:
                CircularProgressIndicator(), // Display the circular progress indicator
          ),
        if (isError)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/error.gif', // Replace with your error animation
                ),
                Text(
                  'Error!',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        if (!isLoading && !isError)
          ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
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
                              // Call the toggleFavorite function
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
      ],
    );
  }
}
