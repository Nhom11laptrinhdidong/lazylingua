import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/quiz_view_model.dart';

class QuizScreen extends StatelessWidget {
  final List<dynamic> words;
  const QuizScreen({Key? key, required this.words}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizViewModel(words),
      child: Consumer<QuizViewModel>(
        builder: (context, vm, _) {
          if (vm.currentQuestion.options.isEmpty) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
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
                        "Mini Quiz",
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
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset('assets/images/anhbautroi.png', fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              vm.getStreakText(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: vm.getStreakFlameColor(),
                              ),
                            ),
                          ),
                          Text(
                            "🏆 Best: ${vm.highestStreak}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Definition:',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                vm.currentQuestion.definition,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 24),
                              ...vm.currentQuestion.options.map((opt) {
                                final isCorrect = opt == vm.currentQuestion.correctAnswer;
                                Color color;
                                if (!vm.showResult) color = Colors.grey.shade200;
                                else if (opt == vm.selectedOption) color = isCorrect ? Colors.green : Colors.red;
                                else if (isCorrect) color = Colors.green;
                                else color = Colors.grey.shade200;

                                return Card(
                                  color: color,
                                  child: ListTile(
                                    title: Text(opt),
                                    onTap: vm.showResult ? null : () => vm.checkAnswer(opt),
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 20),
                              if (vm.showResult)
                                Center(
                                  child: ElevatedButton(
                                    onPressed: vm.generateQuestion,
                                    child: const Text('Next'),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}