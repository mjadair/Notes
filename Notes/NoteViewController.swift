import UIKit


// this is the controller for our single note views
class NoteViewController: UIViewController {
    @IBOutlet var contentTextView: UITextView!
    
    var note: Note? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentTextView.text = note!.content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        note!.content = contentTextView.text
        NoteManager.shared.saveNote(note: note!)
    }
}
