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
    
    
    @IBAction func createNote() {
        let _ = NoteManager.main.create()
        reload()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
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
    
    
    // method to reload the table once the underlying data structure has changed
    func reload() {
        notes = NoteManager.main.getAllNotes()
        self.tableView.reloadData()
    }
      
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSeque" {
            if let destination = segue.destination as?
                NoteViewController {
                destination.note = notes[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    


}

