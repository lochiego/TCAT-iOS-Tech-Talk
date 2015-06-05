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
        
    }
    
    public func delete(note: Task) {
        
    }
    
    public func addListener(listener: NoteEventListener) {
        
    }
    
    public func removeListener(listener: NoteEventListener) {
        
    }
}
