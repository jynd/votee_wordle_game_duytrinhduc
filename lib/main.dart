import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

/// [
///     {
///         "slot": 0,
///         "guess": "b",
///         "result": "absent"
///     },
///     {
///         "slot": 1,
///         "guess": "a",
///         "result": "present"
///     },
///     {
///         "slot": 2,
///         "guess": "r",
///         "result": "absent"
///     },
///     {
///         "slot": 3,
///         "guess": "o",
///         "result": "present"
///     },
///     {
///         "slot": 4,
///         "guess": "n",
///         "result": "absent"
///     }
/// ]

void main() {
  int wordSize = 6;
  guessWord(wordSize);
}

Future<void> guessWord(int wordSize) async {
  /// init alphabet
  List<String> alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');
  String result = '';

  while (result.isEmpty) {
    /// get random word
    String randomWord = generateRandomWord(alphabet, wordSize);
    print('randomWord is guessing: $randomWord');

    /// call API
    final response = await http.get(Uri.parse(
        'https://wordle.votee.dev:8000/daily?guess=$randomWord&size=$wordSize'));

    if (response.statusCode == 200) {
      List feedback = jsonDecode(response.body);

      bool isCorrect = true;
      for (int i = 0; i < feedback.length; i++) {
        if (feedback[i]['result'] != 'correct') {
          isCorrect = false;
          break;
        }
      }

      if (isCorrect) {
        result = randomWord;
        print('final result : $result');
      } else {
        alphabet = removeWrongCharacters(alphabet, feedback);
      }
    } else {
      print('error: ${response.statusCode} - ${response.body}');
    }
  }
}

String generateRandomWord(List<String> alphabet, int wordSize) => List.generate(
    wordSize, (index) => alphabet[Random().nextInt(alphabet.length)]).join();

List<String> removeWrongCharacters(List<String> alphabet, List feedback) {
  for (var feedbackChild in feedback) {
    if (feedbackChild['result'] == 'absent' &&
        alphabet.contains(feedbackChild['guess'])) {
      alphabet.remove(feedbackChild['guess']);
    }
  }
  return alphabet;
}
