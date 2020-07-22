import UIKit

class NotesListViewController: UITableViewController {
    var notes: [Note] = []
    
    
    // The IBAction is the + on our storyboard
    // When the user interacts it calls this function
    // In turn, this calls the create method on the NoteManager model in Note.swift
    // Then reloads
    @IBAction func createNote() {
        let _ = NoteManager.shared.create()
        reload()
    }
    
    
    // Reloads the view, by getting all the notes from the database and reloading the view
    func reload() {
        notes = NoteManager.shared.getNotes()
        tableView.reloadData()
    }
    
    // viewWillAppear is called when the UITableView is about to be brought into focus
    // We call the above reload function when this happens
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    
    // Returns the number of sections in the view. Increasing it to 2 adds two notes each time one is added.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // Returns the number of rows in the list, in this case a row for each note.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    
    // this creates the text field in the list view row. It returns the cell to have the text content of the note.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].content
        return cell
    }
    
    
    // when the note is selected, it prepares the segue, moving us across to the NoteViewController and setting the destination to be at the index of the selected note.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSegue",
                let destination = segue.destination as? NoteViewController,
                let index = tableView.indexPathForSelectedRow?.row {
            destination.note = notes[index]
        }
    }
}
