# ios-word-scramble
Word Scramble Project from Hacking with Swift

## Future Improvements

- [x] Disallow answers that are shorter than three letters.
- [x] Refactor all the `else` statements we just added so that they call a new method called `showErrorMessage()`
- [x] Disallow answers that are just the start word
- [x] Make a new `loadDefaultWords()` method that can be used for failures in our `start.txt` loading code
- [x] Instead of shuffling the complete array everytime `startGame` is called, shuffle once and then use an increasing integer property to read different words when `startGame()` is called?
- [ ] Set a timer for the game to run, and making it start over once completed
- [ ] Set a score for the game, and provide feedback at the end based on score
- [ ] Show the user a screen so they can chooes to continue or quit
- [ ] Create a window to store high scores for the game
