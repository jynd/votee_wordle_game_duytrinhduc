import 'package:flutter_test/flutter_test.dart';
import 'package:votee_wordle_game_duytrinhduc/main2.dart';

void main() {
  group('removeWrongCharacters tests', () {
    test('Test correct guess', () {
      List<List<String>> possibleLetters = [
        ['a', 'b', 'c'],
        ['d', 'e', 'f'],
        ['g', 'h', 'i'],
      ];

      List feedback = [
        {"slot": 0, "guess": "c", "result": "correct"},
      ];

      /// expected result
      List<List<String>> expectedLetters = [
        ['c'],
        ['d', 'e', 'f'],
        ['g', 'h', 'i'],
      ];

      removeWrongCharacters(possibleLetters, feedback);

      expect(possibleLetters, expectedLetters);
    });

    test('Test present guess', () {
      List<List<String>> possibleLetters = [
        ['a', 'b', 'c'],
        ['d', 'e', 'f'],
        ['g', 'h', 'i'],
      ];

      List feedback = [
        {"slot": 1, "guess": "e", "result": "present"},
      ];

      /// expected result
      List<List<String>> expectedLetters = [
        ['a', 'b', 'c'],
        ['d', 'f'], // 'e' is present but in another position
        ['g', 'h', 'i'],
      ];

      removeWrongCharacters(possibleLetters, feedback);

      expect(possibleLetters, expectedLetters);
    });

    test('Test absent guess', () {
      List<List<String>> possibleLetters = [
        ['a', 'b', 'c'],
        ['d', 'e', 'f'],
        ['g', 'h', 'i'],
      ];

      List feedback = [
        {"slot": 2, "guess": "i", "result": "absent"},
      ];

      /// expected result
      List<List<String>> expectedLetters = [
        ['a', 'b', 'c'],
        ['d', 'e', 'f'],
        ['g', 'h'], // remove 'i'
      ];

      removeWrongCharacters(possibleLetters, feedback);

      expect(possibleLetters, expectedLetters);
    });
  });
}
