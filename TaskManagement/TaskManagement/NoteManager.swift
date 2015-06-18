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
    func delete(note: T)
    
    func addListener(listener: NoteEventListener)
    func removeListener(listener: NoteEventListener)
}

public class TaskManager: NoteManager {
    
    private var tasks: [Task] = []
    private var listeners: [NoteEventListener] = []
    
    public init() {
        
    }
    
    public func fetchNotes() -> [Task] {
        return tasks
    }
    
    public func create() -> Task {
        let newTask = Task()
        tasks.append(newTask)
        
        let event = NoteEvent(note: newTask, action: NoteAction.Created)
        broadcast(event)
        
        return newTask
    }
    
    public func delete(note: Task) {
        if let index = find(tasks, note) {
            tasks.removeAtIndex(index)
            broadcast(NoteEvent(note: note, action: NoteAction.Deleted))
        }
    }
    
    public func addListener(listener: NoteEventListener) {
        listeners.append(listener)
    }
    
    public func removeListener(listener: NoteEventListener) {
        for (index, storedListener) in enumerate(listeners) {
            if (storedListener === listener) {
                listeners.removeAtIndex(index)
                break
            }
        }
    }
    
    private func broadcast(event: NoteEvent) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            for (listener) in self.listeners {
                listener.notify(event)
            }
        })
    }
}
