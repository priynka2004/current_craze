import 'package:current_craze/model/news_info_model.dart';
import 'package:current_craze/provider/news_provider.dart';
import 'package:current_craze/screens/news_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class NewsCategoryScreen extends StatefulWidget {
  const NewsCategoryScreen({
    required this.category,
    Key? key,
  }) : super(key: key);

  final String category;

  @override
  NewsCategoryScreenState createState() => NewsCategoryScreenState();
}

class NewsCategoryScreenState extends State<NewsCategoryScreen> {
  final PagingController<int, Articles> _pagingController =
      PagingController(firstPageKey: 1);

  NewsProvider? newsProvider;
  int pageSize = 10;

  Future paginationListener() async {
    _pagingController.addPageRequestListener((pageKey) {
      fetchNews(pageKey);
    });
  }

  @override
  void initState() {
    super.initState();
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
    paginationListener();
  }

  Future<void> fetchNews(int pageKey) async {
    await newsProvider?.fetchNews(
      pageKey: pageKey,
      query: widget.category,
    );
    final isLastPage = newsProvider!.articles?.isEmpty ?? false;
    if (isLastPage) {
      _pagingController.appendLastPage(newsProvider!.articles!);
    } else {
      pageKey++;
      _pagingController.appendPage(
          newsProvider!.articles?.sublist(0, pageSize) ?? [], pageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Consumer<NewsProvider>(
        builder: ((context, newsProvider, child) {
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
                    margin: const EdgeInsets.all(8.0),
                    elevation: 0.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 150,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
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
                          padding: const EdgeInsets.all(8.0),
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
                        const Divider()
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
