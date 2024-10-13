import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

void main() {
  int wordSize = 6;

  solveWordle(wordSize);
}

Future<void> solveWordle(int wordSize) async {
  /// init alphabet
  List<String> alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');
  List<String> correctLetters =
      List.filled(wordSize, ''); // ['','','','','','']
  List<List<String>> possibleLetters =
      List.generate(wordSize, (_) => alphabet.toList());
  String result = '';

  while (result.isEmpty) {
    String randomWord = generateWord(possibleLetters, correctLetters);
    print('guessing: $randomWord');

    /// call API
    final response = await http.get(Uri.parse(
        'https://wordle.votee.dev:8000/daily?guess=$randomWord&size=$wordSize'));

    if (response.statusCode == 200) {
      List feedback = jsonDecode(response.body);

      // print('feedback: $feedback');

      bool isCorrect = true;
      for (var i = 0; i < feedback.length; i++) {
        if (feedback[i]['result'] != 'correct') {
          isCorrect = false;
          break;
        }
      }

      if (isCorrect) {
        result = randomWord;
        print('correct word: $result');
      } else {
        removeWrongCharacters(possibleLetters, feedback);
      }
    } else {
      print('error: ${response.statusCode} - ${response.body}');
      break;
    }
  }
}

String generateWord(
    List<List<String>> possibleLetters, List<String> correctLetters) {
  String result = '';

  for (int i = 0; i < correctLetters.length; i++) {
    if (correctLetters[i].isEmpty) {
      List<String> possible = possibleLetters[i];
      result += possible[Random().nextInt(possible.length)];
    } else {
      result += correctLetters[i];
    }
  }

  return result;
}

void removeWrongCharacters(
    List<List<String>> possibleLetters, List feedback) {

  /// [[a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z],
  /// [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z],
  /// [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z],
  /// [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z],
  /// [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z]]
  for (var feedbackChild in feedback) {
    int slot = feedbackChild['slot'];
    String guess = feedbackChild['guess'];
    String result = feedbackChild['result'];

    if (result == 'correct') {
      possibleLetters[slot] = [guess];
    } else if (result == 'present') {
      possibleLetters[slot].remove(guess);
    } else if (result == 'absent') {
      for (var i = 0; i < possibleLetters.length; i++) {
        possibleLetters[i].remove(guess);
      }
    }
  }
  print('possibleLetters: $possibleLetters');
}
