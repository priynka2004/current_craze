import 'package:current_craze/model/news_info_model.dart';
import 'package:current_craze/provider/news_provider.dart';
import 'package:current_craze/screens/news_category_screen.dart';
import 'package:current_craze/screens/search_news_screen.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key, required this.category});

  final String category;

  @override
  TabScreenState createState() => TabScreenState();
}

class TabScreenState extends State<TabScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final PagingController<int, Articles> pagingController =
      PagingController(firstPageKey: 1);
  NewsProvider? newsProvider;
  int pageSize = 10;

  final List<Tab> topTabs = <Tab>[
    const Tab(text: 'Everything'),
    const Tab(text: 'Business'),
    const Tab(text: 'Entertainment'),
    const Tab(text: 'Health'),
    const Tab(text: 'Science'),
    const Tab(text: 'Sports'),
    const Tab(text: 'Technology'),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 7, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Current Craze',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        bottom: TabBar(
          isScrollable: true,
          controller: tabController,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: 'Everything'),
            Tab(text: 'Business'),
            Tab(text: 'Entertainment'),
            Tab(text: 'Health'),
            Tab(text: 'Science'),
            Tab(text: 'Sports'),
            Tab(text: 'Technology'),
          ],
          labelColor: Colors.black,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchNewsScreen()));
              },
              icon: const Icon(Icons.search)),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.file_copy),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.person_outline),
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          NewsCategoryScreen(
            category: 'Everything',
          ),
          NewsCategoryScreen(
            category: 'Business',
          ),
          NewsCategoryScreen(
            category: 'Entertainment',
          ),
          NewsCategoryScreen(
            category: 'Health',
          ),
          NewsCategoryScreen(
            category: 'Science',
          ),
          NewsCategoryScreen(
            category: 'Sports',
          ),
          NewsCategoryScreen(
            category: 'Technology',
          ),
        ],
      ),
    );
  }
}
