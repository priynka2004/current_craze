import 'package:current_craze/model/news_info_model.dart';
import 'package:current_craze/provider/news_provider.dart';
import 'package:current_craze/screens/news_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class SearchNewsScreen extends StatefulWidget {
  const SearchNewsScreen({
    Key? key,
  }) : super(key: key);

  @override
  SearchNewsScreenState createState() => SearchNewsScreenState();
}

class SearchNewsScreenState extends State<SearchNewsScreen> {
  final PagingController<int, Articles> _pagingController =
      PagingController(firstPageKey: 1);
  NewsProvider? newsProvider;
  TextEditingController searchController = TextEditingController();

  int pageNo = 1;

  Future listener() async {
    _pagingController.addPageRequestListener((pageKey) {
      pageNo = pageKey;
      fetchNews(pageKey);
    });
  }

  @override
  void initState() {
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
    listener();
    super.initState();
  }

  Future<void> fetchNews(int pageKey) async {
    if (searchController.text.isNotEmpty) {
      const int pageSize = 10;
      await newsProvider?.fetchNews(
        pageKey: pageKey,
        query: searchController.text,
      );
      final isLastPage = newsProvider!.articles!.isEmpty;
      if (isLastPage) {
        _pagingController.appendLastPage(newsProvider!.articles!);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(
          newsProvider!.articles!.sublist(0, pageSize),
          nextPageKey,
        );
      }
    } else {
      _pagingController.value = const PagingState<int, Articles>(
        nextPageKey: null,
        itemList: [],
        error: null,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: TextFormField(
          controller: searchController,
          onFieldSubmitted: (value) {
            _pagingController.refresh();
          },
          decoration: const InputDecoration(
            hintText: 'Search news',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          return PagedListView<int, Articles>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Articles>(
              itemBuilder: (context, article, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NewsDetailScreen(articles: article);
                        },
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            article.urlToImage.toString(),
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                color: Colors.grey,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                article.description ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                );
              },
              noItemsFoundIndicatorBuilder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
