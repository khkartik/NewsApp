import 'package:dio/dio.dart';
import 'package:river_pod/view_models/news_model.dart';

class Api {
  final apiKey = "33fffc50713f45cea70b54b5b7c37013";
  final Dio _dio = Dio();

  Future<List<Article>> allNews() async {
    final url = "https://newsapi.org/v2/everything?q=keyword&apiKey=$apiKey";

    try {
      var response = await _dio.get(
        url,
        options: Options(
          headers: {"apiKey": apiKey, "Authorization": "Bearer $apiKey"},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = response.data as Map<String, dynamic>;

        var newsResponse = NewsResponse.fromJson(jsonResponse);

        print('Number of news articles: ${newsResponse.totalResults}.');

        return newsResponse.articles;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return [];
      }
    } catch (e) {
      print('Request failed with error: $e');
      return [];
    }
  }

  Future<List<Article>> searchNews(String search) async {
    final url = "https://newsapi.org/v2/everything?q=$search&apiKey=$apiKey";
    try {
      var response = await _dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $apiKey"}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = response.data as Map<String, dynamic>;
        var newsResponse = NewsResponse.fromJson(jsonResponse);

        print('Found ${newsResponse.articles.length} articles for "$search".');

        return newsResponse.articles;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return [];
      }
    } catch (e) {
      print('Request failed with error: $e');
      return [];
    }
  }
}
