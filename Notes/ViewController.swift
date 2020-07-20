//
//  ViewController.swift
//  Notes
//
//  Created by Michael Adair on 20/07/2020.
//  Copyright © 2020 Michael Adair. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var notes: [Note] = []
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // We need three methods implemented when intialising a table view controller:
    
    
    // 1: Number of Sections
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // 2: The Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // this is the size of our notes array
        return notes.count
    }
    
    
    // 3: Cell for row index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].contents
        return cell
    }
      
    
    


}

