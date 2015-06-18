//
//  NoteManager.swift
//  TaskManagement
//
//  Created by Eric Gonzalez on 6/4/15.
//  Copyright (c) 2015 Texas A&M Engineering Experiment Station. All rights reserved.
//

import Foundation



public enum TaskAction {
    case Created, Updated, Deleted
}

public protocol TaskListener: class {
    func notify(event: TaskEvent)
}

public class TaskManager: InternalTaskListener {
    
    private var tasks: [Task] = []
    private var listeners: [TaskListener] = []
    
    public init() {
        // no-op
    }
    
    public func fetchTasks() -> [Task] {
        return tasks
    }
    
    public func create() -> Task {
        var newTask = Task()
        newTask.listener = self
        
        tasks.append(newTask)
        
        let event = TaskEvent(task: newTask, action: TaskAction.Created)
        broadcast(event)
        
        return newTask
    }

    public func delete(task: Task) {
        if let index = find(tasks, task) {
            tasks.removeAtIndex(index)
            broadcast(TaskEvent(task: task, action: TaskAction.Deleted))
        }
    }
    
    public func addListener(listener: TaskListener) {
        listeners.append(listener)
    }
    
    public func removeListener(listener: TaskListener) {
        for (index, storedListener) in enumerate(listeners) {
            if (storedListener === listener) {
                listeners.removeAtIndex(index)
                break
            }
        }
    }
    
    private func broadcast(event: TaskEvent) {
        for (listener) in self.listeners {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                listener.notify(event)
            })
        }
    }
    
    // Internal Task Listener
    func notify(event: TaskEvent) {
        broadcast(event)
    }
}
