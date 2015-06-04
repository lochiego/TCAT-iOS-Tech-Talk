//
//  NoteManager.swift
//  TaskManagement
//
//  Created by Eric Gonzalez on 6/4/15.
//  Copyright (c) 2015 Texas A&M Engineering Experiment Station. All rights reserved.
//

import Foundation

public enum NoteAction {
    case Created, Updated, Deleted
}

public struct NoteEvent {
    let note: Note
    let action: NoteAction
}

public protocol NoteEventListener : class {
    func notify(event: NoteEvent)
}

public protocol NoteManager {
    func fetchNotes() -> [Note]
    func create() -> Note
    func save(note: Note)
    func delete(note: Note)
    
    func addListener(listener: NoteEventListener)
    func removeListener(listener: NoteEventListener)
}
