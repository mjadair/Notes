//
//  Note.swift
//  Notes
//
//  Created by Michael Adair on 20/07/2020.
//  Copyright © 2020 Michael Adair. All rights reserved.
//

import Foundation
import SQLite3


struct Note {
    let id: Int
    let contents: String
}


class NoteManager {
    var database: OpaquePointer!
    
    func connect() {
        
        if database != nil {
            return
        }
        
         
        do {
            
        let databaseURL = try FileManager.default.url(for: .userDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("notes.sqlit3")
            
            
           if sqlite3_open(databaseURL.path, &database) == SQLITE_OK {
               if  sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS notes (contents TEXT)", nil, nil, nil) == SQLITE_OK {
                    
                    
                }
                
               else {
                print ("could not create table")
            }
            
            
            }
            
            else {
                print("could not connect")
            }
            
            
    }
    catch let error {
        print("could not create database")
    }
        
    }
    
    
    // Create a new note function
    func create() -> Int {
        connect()
        
        
        var statement: OpaquePointer!

        if  sqlite3_prepare(database, "INSERT INTO notes (contents) VALUES ('New note')", -1, &statement, nil) == SQLITE_OK {
            print("could not create query")
            return -1
            
        }
            
            if sqlite3_step(statement) == SQLITE_OK {
                   print("Could not insert note")
            }
            
            sqlite3_finalize(statement)
            return Int(sqlite3_last_insert_rowid(database))
        }
    
    
    // get all notes function
    
    func getAllNotes() -> [Note] {
        connect()
        
        var result: [Note] = []
        
        
        var statement: OpaquePointer!
        
        if sqlite3_prepare(database, "SELECT rowid, contents FROM notes", -1,  &statement, nil) != SQLITE_OK {
            print("Error creating select!")
            return []
        }
        
        
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Note(id: Int(sqlite3_column_int(statement, 0)), contents: String(cString: sqlite3_column_text(statement, 1))))
        }
        
        
        sqlite3_finalize(statement)
        return result
        
    }
    
}
