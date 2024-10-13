# Wordle Solver

This `README` covers the project purpose, setup instructions.

## Project Purpose

This project implements a Wordle solver that guess words based on feedback from Wordle API. 
The solver aims to minimize the number of guesses by refining the possible letter pool after each search.

## Features
- Generates word guesses based on an adaptive alphabet refinement process.
- Calls an external API (/daily) to evaluate word guesses and receives feedback on letter correctness.
- Handles edge cases when the correct word is found or when invalid characters are detected.

## Installation

To run the project locally, follow these steps:

1. Clone the repository:
   ```
   git clone https://github.com/jynd/votee_wordle_game_duytrinhduc
   ```
2. Install Dart dependencies:
   ```
   dart pub get
   ```
3. Run the code:
   ```
   dart run main.dart
   ```
   or
   ```
   dart run main2.dart
   ```
   
## Explanation of Algorithm

1. **Initial Guessing**: The algorithm starts by guessing a random word generated from a pool of letters (alphabet).
2. **API Interaction**: The guess is sent to the '/daily' aPI, which evaluates the word and returns feedback on the correctness of each letter.
3. **Feedback Processing**: Based on the feedback, the solver refines the list of potential letters by removing incorrect ones and prioritizing correct guesses.
4. **Algorithm**: The solver continues guessing with a refined alphabet, reducing the search space after each attempt, improving efficiency with every iteration.

## Contribution

Feel free to submit issues or contribute to the project by making pull requests. Contributions that improve the guessing algorithm or optimize the performance are highly welcome.

## License
This project is licensed under the MIT license.