import Foundation
import SQLite3


// Our Note Model
struct Note {
    var id: Int32
    var content: String
}

// Note Manager model
class NoteManager {
    
    // our database is SQL so its type is OpaquePointer because it cannot be represented in Swift
    var database: OpaquePointer?
    
    static let shared = NoteManager()
    
    private init() {
    }
    
    // this function connects to our database, and creates one if it doesn't already exist
    func connect() {
        if database != nil {
            return
        }
        
        let databaseURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("notes.sqlite")
        
        if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        if sqlite3_exec(
            database,
            """
            CREATE TABLE IF NOT EXISTS notes (
                content TEXT
            )
            """,
            nil,
            nil,
            nil
        ) != SQLITE_OK {
            print("Error creating table: \(String(cString: sqlite3_errmsg(database)!))")
        }
    }
    
    
    // This method creates a new note, it has the  default content of 'Write a new note!'
    func create() -> Int {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "INSERT INTO notes (content) VALUES ('Write a note!')",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error inserting note")
            }
        }
        else {
            print("Error creating note insert statement")
        }
        
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    
    // this method gets and returns our single note. The result is an empty array and the returned values from the sql query are appended to it.
    func getNotes() -> [Note] {
        connect()
        
        var result: [Note] = []
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, "SELECT rowid, content FROM notes", -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                result.append(Note(
                    id: sqlite3_column_int(statement, 0),
                    content: String(cString: sqlite3_column_text(statement, 1))
                ))
            }
        }
        
        sqlite3_finalize(statement)
        return result
    }
    
    
    // This function saves our updated note to the existing record. 
    func saveNote(note: Note) {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "UPDATE notes SET content = ? WHERE rowid = ?",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, NSString(string: note.content).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, note.id)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error saving note")
            }
        }
        else {
            print("Error creating note update statement")
        }
        
        sqlite3_finalize(statement)
    }
    
    
    
    func deleteNote(id: Int32) -> Bool {
        connect()
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM notes WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("error while preparing sql statement")
            return false
        }
        
        sqlite3_bind_int(statement, 1, id)
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("error while trying to delete the note")
            return false
        }
        
        sqlite3_finalize(statement)
        return true
    }
    
    
    
    
    
    
}
