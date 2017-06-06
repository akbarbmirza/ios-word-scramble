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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // find the path to our start.txt file
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            // load the contents of that file
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                // splitting the contents of that file into an array
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            allWords = ["silkworm"]
        }

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

    // will be called every time we want to generate a new word for the player
    // to work with, and will shuffle the allWords array and pick the first item
    func startGame() {

        // shuffle the words array
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        // sets title of our view controller to the first word in the array
        title = allWords[0]
        // reset our usedWords array
        usedWords.removeAll(keepingCapacity: true)
        // reload our tableView
        tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
