class Endpoints {
  static const String baseUrl =
      'https://newsapi.org/v2/everything';

  static String getNewsByPaginationUrl({
    required String apiKey,
    required String query,
    required String sortBy,
    int page = 0,
    int pageSize = 10,
  }) {
    return '$baseUrl?'
        'apiKey=$apiKey'
        '&q=$query'
        '&sortBy=$sortBy'
        '&page=$page'
        '&pageSize=$pageSize';
  }
}
