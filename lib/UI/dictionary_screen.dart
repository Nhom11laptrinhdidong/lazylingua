import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/bookmark.dart';
import 'translate_modal.dart';
import 'package:lottie/lottie.dart';

class DictionaryScreen extends StatefulWidget {
  final List<dynamic> words;
  const DictionaryScreen({Key? key, required this.words}) : super(key: key);

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  double _xPosition = 250;
  double _yPosition = 35;
  List<dynamic> allWords = [];
  List<dynamic> filteredWords = [];
  TextEditingController searchController = TextEditingController();
  bool showBookmarksOnly = false;


  @override
  void initState() {
    super.initState();
    allWords = widget.words;
    filteredWords = widget.words;
    searchController.addListener(onSearchChanged);
  }

  void onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredWords = allWords
          .where((word) => word['word'].toLowerCase().contains(query))
          .toList();

      if (showBookmarksOnly) {
        filteredWords = filteredWords.where((word) {
          return context.read<BookmarkManager>().isBookmarked(word['word']);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/nen.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: kToolbarHeight,
                margin: EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "Dictionary",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Remove the title since we're using flexibleSpace
            title: null,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Hide keyboard when tapping outside text field
          FocusScope.of(context).unfocus();
        },
        child:
        Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: "Tìm kiếm từ...",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.blue),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              onSearchChanged(); // nếu bạn cần cập nhật lại danh sách khi xóa
                              setState(() {});   // cập nhật lại UI để ẩn nút x khi trống
                            },
                          )
                              : null,
                        ),
                        onChanged: (value) => setState(() {}), // cần thiết để hiển thị/ẩn nút x theo nội dung
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            showBookmarksOnly = !showBookmarksOnly;
                            onSearchChanged();
                          });
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: showBookmarksOnly,
                              onChanged: (bool? value) {
                                setState(() {
                                  showBookmarksOnly = value!;
                                  onSearchChanged();
                                });
                              },
                            ),
                            Text("Chỉ hiển thị từ đã đánh dấu"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredWords.length,
                    itemBuilder: (context, index) {
                      var word = filteredWords[index];
                      bool isBookmarked = context.watch<BookmarkManager>().isBookmarked(word['word']);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordDetailScreen(word: word),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.blue, width: 1),),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        word['word'],
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        word['pos'],
                                        style: TextStyle(color: Colors.grey[900]),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                    color: isBookmarked ? Colors.amber : null,
                                  ),
                                  onPressed: () {
                                    context.read<BookmarkManager>().toggleBookmark(word);
                                  },
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

            // Ảnh tròn có thể di chuyển
            Positioned(
              left: _xPosition,
              top: _yPosition,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _xPosition = (_xPosition + details.delta.dx)
                        .clamp(0, MediaQuery.of(context).size.width - 120); // chiều ngang
                    _yPosition = (_yPosition + details.delta.dy)
                        .clamp(0, 440);
                  });
                },
                onTap: () {
                  showCustomModal(context);
                },
                child: Lottie.asset(
                  'assets/Json/conluoi.json',
                  width: 120,
                  height: 120,
                  repeat: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

class WordDetailScreen extends StatelessWidget {
  final Map<String, dynamic> word;

  WordDetailScreen({required this.word});

  @override
  Widget build(BuildContext context) {
    bool isBookmarked = context.watch<BookmarkManager>().isBookmarked(word['word']);

    return Scaffold(
      appBar: AppBar(
        title: Text(word['word']),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.amber : null,
            ),
            onPressed: () {
              context.read<BookmarkManager>().toggleBookmark(word);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  word['word'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                SelectableText(
                  word['pos'],
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 10),
                if (word['phonetic_text'] != null)
                  SelectableText(
                    "Phonetic: ${word['phonetic_text']}",
                    style: TextStyle(fontSize: 16),
                  ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: word['senses'].length,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      var sense = word['senses'][index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                "• ${sense['definition']}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: sense['examples'].map<Widget>((example) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 16.0, top: 4.0),
                                    child: SelectableText(
                                      "- ${example['x']}",
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Đặt icon dịch ở góc phải
          Positioned(
            right: 16,
            top: 16,
            child: GestureDetector(
              onTap: () {
                showCustomModal(context);
              },
              child: Lottie.asset(
                'assets/Json/conluoi.json',
                width: 120,
                height: 120,
                repeat: true,
              ),
            ),
          ),

        ],
      ),
    );
  }
}