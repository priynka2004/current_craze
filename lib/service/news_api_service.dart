import 'dart:convert';
import 'package:current_craze/model/news_info_model.dart';
import 'package:current_craze/shared/api_endPoint.dart';
import 'package:current_craze/shared/app_const.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NewsApiService {
  static const int pageSize = 20;

  static Future<List<Articles>> fetchNews({
    required int pageKey,
    required String query,
  }) async {
    if (kDebugMode) {
      print('FetchingNews category=$query');
    }

    final url = Endpoints.getNewsByPaginationUrl(
      apiKey: AppConstant.apiKey,
      query: query,
      sortBy: 'publishedAt',
      page: pageKey,
      pageSize: pageSize,
    );

    final response = await http.get(Uri.parse(url));
    Map<String, dynamic> map = jsonDecode(response.body);
    if (response.statusCode == 200) {
      NewsInfo newsInfo = NewsInfo.fromJson(map);
      final List<Articles> articles = newsInfo.articles ?? [];
      return articles;
    } else {
      if (map['message'] != null) {
        throw map['message'];
      }
    }
    throw "Something went wrong";
  }
}


