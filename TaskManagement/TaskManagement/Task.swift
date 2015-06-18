/*******************************************************************************
* Copyright © 2007-15, All Rights Reserved.
* Texas Center for Applied Technology
* Texas A&M Engineering Experiment Station
* The Texas A&M University System
* College Station, Texas, USA 77843
*
* Use is granted only to authorized licensee.
* Proprietary information, not for redistribution.
******************************************************************************/

import Foundation


// Task

public enum TaskProperty {
    case Name, Description, Deadline, Urgent, Important
}

public struct TaskEvent {
    let task: Task
    let action: TaskAction
    let property: TaskProperty?
    let oldValue: Any?
    let newValue: Any?
    
    init(task: Task, action: TaskAction = .Updated, property: TaskProperty? = nil, oldValue: Any? = nil, newValue: Any? = nil)
    {
        self.task = task
        self.action = action
        self.property = property
        self.oldValue = oldValue
        self.newValue = newValue
    }
}

protocol InternalTaskListener : class {
    func notify(event: TaskEvent)
}

public class Task: Equatable {
    weak var listener: InternalTaskListener? = nil
    
    public let id: NSUUID
    public var name: String { didSet {
        self.notify(.Name, oldValue: oldValue, newValue: self.name)
        } }
    public var description: String { didSet {
        self.notify(.Description, oldValue: oldValue, newValue: self.description)
        } }
    public let created: NSDate
    public var deadline: NSDate? { didSet {
        self.notify(.Deadline, oldValue: oldValue, newValue: self.deadline)
        } }
    public var urgent: Bool { didSet {
        self.notify(.Urgent, oldValue: oldValue, newValue: self.urgent)
        } }
    public var important: Bool { didSet {
        self.notify(.Important, oldValue: oldValue, newValue: self.important)
        } }

    init(id: NSUUID = NSUUID(), name: String = "", description: String = "", created: NSDate = NSDate(), deadline: NSDate? = nil, urgent: Bool = false, important: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.created = created
        self.deadline = deadline
        self.urgent = urgent
        self.important = important
    }
    
    func notify(property: TaskProperty, oldValue: Any?, newValue: Any?)
    {
        listener?.notify(TaskEvent(task: self, property: property, oldValue: oldValue, newValue: newValue))
    }
}

public func == (lhs: Task, rhs: Task) -> Bool {
    return lhs.id == rhs.id
}
