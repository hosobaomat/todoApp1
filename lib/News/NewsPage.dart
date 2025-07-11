import 'package:flutter/material.dart';
import 'package:todoapp1/News/WebViewPage.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'dart:convert'; // cần thiết để dùng jsonDecode

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<RssItem> _articles = [];

  @override
  void initState() {
    super.initState();
    fetchRss();
  }

  Future<void> fetchRss() async {
    final response = await http.get(Uri.parse(
      'https://api.rss2json.com/v1/api.json?rss_url=https://tuoitre.vn/rss/tin-moi-nhat.rss',
    ));

    if (response.statusCode == 200) {
      print('thanh cong');
      final json = jsonDecode(response.body);
      final items = json['items'] as List;

      setState(() {
        _articles = items.map((item) {
          return RssItem(
            title: item['title'],
            link: item['link'],
            pubDate: DateTime.tryParse(item['pubDate'] ?? ''),
            description: item['description'],
          );
        }).toList();
      });
    } else {
      print("Lỗi khi gọi RSS API: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tin tức VnExpress",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final item = _articles[index];
          return ListTile(
            leading: const Icon(Icons.article),
            title: Text(item.title ?? ''),
            subtitle: Text(item.pubDate?.toString() ?? ''),
            onTap: () {
              // mở trình duyệt đọc bài
              final url = item.link ?? '';
              if (url.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WebViewPage(url: url),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
