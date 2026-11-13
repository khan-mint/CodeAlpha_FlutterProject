import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
  
class Flashcard {
  String question;
  String answer;
  Flashcard({required this.question, required this.answer});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcard Quiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FlashcardScreen(),
    );
  }
}

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<Flashcard> cards = [
    Flashcard(question: 'What is Flutter?', answer: 'Flutter is Google\'s UI toolkit for building apps.'),
    Flashcard(question: 'What is Dart?', answer: 'Dart is the programming language used by Flutter.'),
    Flashcard(question: 'What is StatefulWidget?', answer: 'A widget that can change its state over time.'),
  ];

  int currentIndex = 0;
  bool showAnswer = false;

  void nextCard() {
    if (currentIndex < cards.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    }
  }

  void prevCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showAnswer = false;
      });
    }
  }

  void showAddEditDialog({Flashcard? card, int? index}) {
    TextEditingController qController = TextEditingController(text: card?.question ?? '');
    TextEditingController aController = TextEditingController(text: card?.answer ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(card == null ? 'Add Flashcard' : 'Edit Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: qController, decoration: const InputDecoration(labelText: 'Question')),
            const SizedBox(height: 12),
            TextField(controller: aController, decoration: const InputDecoration(labelText: 'Answer')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (qController.text.isNotEmpty && aController.text.isNotEmpty) {
                setState(() {
                  if (card == null) {
                    cards.add(Flashcard(question: qController.text, answer: aController.text));
                    currentIndex = cards.length - 1;
                  } else {
                    cards[index!] = Flashcard(question: qController.text, answer: aController.text);
                  }
                  showAnswer = false;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void deleteCard() {
    setState(() {
      cards.removeAt(currentIndex);
      if (currentIndex >= cards.length && cards.isNotEmpty) currentIndex = cards.length - 1;
      if (cards.isEmpty) currentIndex = 0;
      showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Quiz'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => showAddEditDialog()),
        ],
      ),
      body: cards.isEmpty
          ? const Center(child: Text('No flashcards. Tap + to add one.'))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Card ${currentIndex + 1} / ${cards.length}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(showAnswer ? 'ANSWER' : 'QUESTION', style: TextStyle(color: Colors.grey[600], letterSpacing: 2)),
                            const SizedBox(height: 16),
                            Text(
                              showAnswer ? cards[currentIndex].answer : cards[currentIndex].question,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () => setState(() => showAnswer = !showAnswer),
                              child: Text(showAnswer ? 'Hide Answer' : 'Show Answer'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(onPressed: prevCard, icon: const Icon(Icons.arrow_back), label: const Text('Previous')),
                      ElevatedButton.icon(onPressed: nextCard, icon: const Icon(Icons.arrow_forward), label: const Text('Next')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(icon: const Icon(Icons.edit), label: const Text('Edit'), onPressed: () => showAddEditDialog(card: cards[currentIndex], index: currentIndex)),
                      TextButton.icon(icon: const Icon(Icons.delete, color: Colors.red), label: const Text('Delete', style: TextStyle(color: Colors.red)), onPressed: deleteCard),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}