import 'package:current_craze/model/news_info_model.dart';
import 'package:current_craze/service/news_api_service.dart';
import 'package:flutter/foundation.dart';

class NewsProvider extends ChangeNotifier{
  List<Articles>? articles;
  Future fetchNews({required int pageKey, required String query}) async {
    try{
      articles = await NewsApiService.fetchNews(pageKey: pageKey, query: query);
    }
    catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
  }
}



