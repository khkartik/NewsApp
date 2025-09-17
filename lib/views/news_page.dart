import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/providers/providers.dart';
import 'package:river_pod/views/decription_page.dart';
import 'package:river_pod/views/search_page.dart';

class NewsPage extends ConsumerWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("News", style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => SearchPage()));
          },
          child: Icon(Icons.search, color: Colors.white),
        ),
      ),
      body: Container(
        child: newsAsync.when(
          data:
              (news) => ListView.builder(
                itemCount: news.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading:
                        news[index].urlToImage != null
                            ? Image.network(
                              news[index].urlToImage!,
                              width: 100,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                            : const Icon(Icons.image_not_supported),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => DecriptionPage(
                                  title: news[index].title,
                                  description: news[index].description ?? "",
                                ),
                          ),
                        );
                      },
                      child: Text(news[index].title),
                    ),
                    subtitle: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => DecriptionPage(
                                  title: news[index].title,
                                  description: news[index].description ?? "",
                                ),
                          ),
                        );
                      },
                      child: Text(news[index].description ?? ""),
                    ),
                  );
                },
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("Error: $err")),
        ),
      ),
    );
  }
}
