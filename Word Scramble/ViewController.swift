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
    
    // Properties
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // if there is a file called start.txt
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    // TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    func startGame() {
        // shuffle our allWords array
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        // set the title to the first entry in allWords
        // the word our player has to find
        title = allWords[0]
        // empty our usedWords array
        usedWords.removeAll(keepingCapacity: true)
        // reload our tableView
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

