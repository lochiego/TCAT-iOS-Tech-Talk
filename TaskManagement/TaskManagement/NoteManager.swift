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
    typealias T: Note
    func fetchNotes() -> [T]
    func create() -> T
    func updateProperty(note: T, property: String, value: AnyObject?)
    func delete(note: T)
    
    func addListener(listener: NoteEventListener)
    func removeListener(listener: NoteEventListener)
}

public class TaskManager: NoteManager {
    
    private var tasks: [Task] = []
    
    public func fetchNotes() -> [Task] {
        return tasks
    }
    
    public func create() -> Task {
        let newTask = Task()
        tasks.append(newTask)
        return newTask
    }
    
    public func updateProperty(note: Task, property: String, value: AnyObject?) {
        var newName = note.name
        var newDescription = note.description
        var newDeadline = note.deadline
        var newUrgent = note.urgent
        var newImportant = note.important
        
        switch property {
        case Constants.Task.NAME: newName = value as! String
        case Constants.Task.DESCRIPTION: newDescription = value as! String
        case Constants.Task.DEADLINE: newDeadline = value as! NSDate?
        case Constants.Task.URGENT: newUrgent = value as! Bool
        case Constants.Task.IMPORTANT: newImportant = value as! Bool
        default: assert(false, "Property \(property) is not defined for Task")
        }
        
        let newNote = Task(id: note.id, name: newName, description: newDescription, deadline: newDeadline, urgent: newUrgent, important: newImportant)
        
        if let index = find(tasks, newNote) {
            tasks[index] = newNote
        }
        else {
            tasks.append(newNote)
        }
    }
    
    public func delete(note: Task) {
        if let index = find(tasks, note) {
            tasks.removeAtIndex(index)
        }
    }
    
    public func addListener(listener: NoteEventListener) {
        
    }
    
    public func removeListener(listener: NoteEventListener) {
        
    }
}
