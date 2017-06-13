//
//  ViewController.swift
//  Word Scramble
//
//  Created by Akbar Mirza on 2/13/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UITableViewController {

    // Outlets
    // -------------------------------------------------------------------------

    // Properties
    // -------------------------------------------------------------------------

    // list to hold all words in the input file
    var allWords = [String]()
    // list to hold all words the player has currently used in the game
    var usedWords = [String]()
    // create a variable to hold the current index of the shuffled words
    var index = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        // find the path to our start.txt file
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            // load the contents of that file
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                // splitting the contents of that file into an array
                allWords = startWords.components(separatedBy: "\n")
            } else {
                // if contents cannot be properly loaded, load default words
                loadDefaultWords()
            }
        } else {
            // if start.txt cannot be found, load default words
            loadDefaultWords()
        }
        
        // shuffle the words array once when the app has loaded
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        // start the game
        startGame()

    }

    // TableView Methods
    // -------------------------------------------------------------------------

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue our custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        // set the cell's text equal to the corresponding entry in usedWords
        cell.textLabel?.text = usedWords[indexPath.row]
        // return our cell
        return cell
    }

    // Helper Functions
    // -------------------------------------------------------------------------
    
    // will try to load default words if loading from start.txt fails
    func loadDefaultWords() {
        allWords = ["aardvark", "berrying", "coconuts", "desolate", "silkworm"]
    }
    
    // will be called every time we want to generate a new word for the player
    // to work with, and will shuffle the allWords array and pick the first item
    func startGame() {
        // sets title of our view controller to the first word in the array
        title = allWords[index]
        // increment our index
        index += 1
        // reset our usedWords array
        usedWords.removeAll(keepingCapacity: true)
        // reload our tableView
        tableView.reloadData()
    }
    
    func promptForAnswer() {
        // create an alert controller
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction) in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        
        // present the alert controller we've made
        present(ac, animated: true)
    }
    
    // this method checks if the given answer is valid, add it to the usedWords
    // array, and update our table to show that word.
    // for an answer to be valid, it must satisfy the following criteria:
    //     (1) can the word be made from the given letters?
    //     (2) has the word been used already?
    //     (3) is the word a valid English word?
    func submit(answer: String) {
        // make our submit function case-insensitive
        let lowerAnswer = answer.lowercased()
        
        // if answer is the same as the title, reject it
        if lowerAnswer == title?.lowercased() {
            showErrorMessage(title: "Can't use the same word",
                             message: "You didn't think it was that easy, did you?")
            return
        }
        
        // (1) can the word be made from the given letters?
        if isPossible(word: lowerAnswer) {
            // (2) has the word been used already?
            if isOriginal(word: lowerAnswer) {
                // (3) is the word a valid English word?
                if isReal(word: lowerAnswer) {
                    // add the word to the front of the usedWords array
                    usedWords.insert(answer, at: 0)
                    
                    // set the indexPath to the first row
                    let indexPath = IndexPath(row: 0, section: 0)
                    // insert a row into our tableView at that indexPath
                    tableView.insertRows(at: [indexPath], with: .top)
                    
                    // end the function call
                    return
                } else {
                    // no, it is not a valid English word
                    showErrorMessage(title: "Word not recognised",
                                     message: "You can't just make them up, you know!")
                }
            } else {
                // yes, the word has already been used
                showErrorMessage(title: "Word used already",
                                 message: "Be more original!")
            }
        } else {
            // no, the word can't be made from the given letters
            showErrorMessage(title: "Word not possible",
                             message: "You can't spell that word from '\(title!.lowercased())'!")
        }
        
    }
    
    // given a word, this function returns true if it can be made from the given
    // letters
    func isPossible(word: String) -> Bool {
        // create a temporary word to check against
        var tempWord = title!.lowercased()
        
        // for each letter in our word...
        for letter in word.characters {
            // if current letter is found in our tempWord
            if let pos = tempWord.range(of: String(letter)) {
                // remove that letter from our tempWord
                tempWord.remove(at: pos.lowerBound)
            } else {
                // otherwise, return false because there's a mismatch
                return false;
            }
        }
        
        // if we make it here, then we know that our word is possible
        return true
    }
    
    // given a word, this function returns true if it isn't already in usedWords
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word);
    }
    
    // given a word, this function returns true if it is a valid English word
    func isReal(word: String) -> Bool {
        
        // if word length is under 3 letters, we can skip the isReal check
        if word.characters.count < 3 {
            return false;
        }
        
        // creating an instance of UITextChecker so that we can check for
        // mispellings
        let checker = UITextChecker()
        // creates a strange for us to be able to check later on
        let range = NSMakeRange(0, word.utf16.count)
        // tells us where our mispelling is
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        // if no mispelling was found, the word is valid in english
        return mispelledRange.location == NSNotFound
    }
    
    // creates an alert that shows the user the error title and message
    func showErrorMessage(title: String, message: String) {
        // create an alert to tell the user about the error
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // add the OK action so user can dismiss the alert
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        // present the alert to the user
        present(ac, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
