# ios-word-scramble
Word Scramble Project from Hacking with Swift

## Future Improvements

- [ ] Disallow answers that are shorter than three letters.
  - add a check in `isReal()` that returns false if word length is under three letters
- [ ] Refactor all the `else` statements we just added so that they call a new method called `showErrorMessage()`
- [ ] Disallow answers that are just the start word
- [ ] Make a new `loadDefaultWords()` method that can be used for failures in our `start.txt` loading code
- [ ] Instead of shuffling the complete array everytime `startGame` is called, shuffle once and then use an increasing integer property to read different words when `startGame()` is called?
