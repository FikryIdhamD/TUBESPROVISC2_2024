import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stproject/main.dart';
import 'bloc.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late List<Artikel> filteredArticles;
  late List<Artikel> allArticles;

  @override
  void initState() {
    super.initState();
    // Fetch data when the page is initialized
    context.read<ArtikelProvider>().fetchData();
    filteredArticles = [];
    allArticles = [];
  }

  void filterArticles(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredArticles = allArticles;
      } else {
        filteredArticles = allArticles
            .where((article) => article.titleArtikel
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Articles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Consumer<ArtikelProvider>(
        builder: (context, artikelProvider, child) {
          if (allArticles.isEmpty) {
            allArticles = artikelProvider.artikels;
            filteredArticles = allArticles;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    onChanged: (value) => filterArticles(value),
                    decoration: InputDecoration(
                      hintText: 'Search Articles',
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleDetailPage(
                                article: filteredArticles[index],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gambar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    child: Image.network(
                                      filteredArticles[index].fotoArtikel,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                // Judul dan teks
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredArticles[index].titleArtikel,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        filteredArticles[index]
                                            .deskripsiArtikel,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final Artikel article;

  ArticleDetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageHeight = screenWidth * 0.6; // Adjust height for better view
    return Scaffold(
      appBar: AppBar(
        // Tombol kembali pada AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul artikel
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 16.0, left: 20.0, right: 20.0),
              child: Text(
                article.titleArtikel,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            // Gambar artikel
            SizedBox(
              width: screenWidth,
              height: imageHeight,
              child: Image.network(
                article.fotoArtikel,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            // Konten artikel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Text(
                article.deskripsiArtikel,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
