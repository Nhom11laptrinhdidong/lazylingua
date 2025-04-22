import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/bookmark.dart';
import '../UI/translate_modal.dart';
import 'package:lottie/lottie.dart';

class FlashCardScreen extends StatefulWidget {
  final List<dynamic> words;
  const FlashCardScreen({Key? key, required this.words}) : super(key: key);

  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  late List<dynamic> allWords;
  dynamic currentWord;
  bool showAnswer = false;
  final Random random = Random();

  // Vị trí của nút kéo thả
  double _xPosition = 0;
  double _yPosition = 0;

  @override
  void initState() {
    super.initState();
    allWords = widget.words
        .where((word) => word['senses'] != null && word['senses'].isNotEmpty)
        .toList();
    pickRandomWord();
  }

  void pickRandomWord() {
    if (allWords.isNotEmpty) {
      setState(() {
        currentWord = allWords[random.nextInt(allWords.length)];
        showAnswer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (allWords.isEmpty || currentWord == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final definition = currentWord['senses'][0]['definition'];
    final phonetic = currentWord['phonetic_text'] ?? '';
    bool isBookmarked = context.watch<BookmarkManager>()
        .isBookmarked(currentWord['word']);

    return Scaffold(
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
                  "Flash Cards",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: null,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Ảnh nền
          Positioned.fill(
            child: Image.asset(
              'assets/images/anhbautroi.png',
              fit: BoxFit.cover,
            ),
          ),

          // Giao diện chính
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () {
                      showAnswer = !showAnswer;
                      setState(() {});
                    },
                    child: Card(
                      shadowColor: Colors.blue,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.blue, width: 2),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(24),
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage('assets/images/nen1.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentWord['word'],
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3.0,
                                        color: Colors.black,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                if (showAnswer) ...[
                                  if (phonetic.isNotEmpty)
                                    Text(
                                      "Phonetic: $phonetic",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 3.0,
                                            color: Colors.black,
                                            offset: Offset(1.0, 1.0),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  SizedBox(height: 10),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxHeight: 120, // Chỉ cho phép definition hiển thị trong khoảng này
                                    ),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        "Meaning: $definition",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 3.0,
                                              color: Colors.black,
                                              offset: Offset(1.0, 1.0),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ] else
                                  Text(
                                    "Tap this card to reveal",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 3.0,
                                          color: Colors.black,
                                          offset: Offset(1.0, 1.0),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.amber : null,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {context.read<BookmarkManager>().toggleBookmark(currentWord);},
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: pickRandomWord,
                        icon: Icon(Icons.next_plan),
                        label: Text("Next word"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Nút kéo/thả hiển thị trình dịch
          Positioned(
            left: _xPosition,
            top: _yPosition,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _xPosition = (_xPosition + details.delta.dx)
                      .clamp(0, MediaQuery.of(context).size.width - 120);
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
    );
  }
}
