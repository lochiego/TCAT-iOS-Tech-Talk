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


public enum TaskProperty {
    case Name, Description, Deadline, Important
}

public enum Deadline {
    case NextMonth, NextWeek, Tomorrow, Lunch
    public func intValue() -> Int {
        switch self {
        case .NextMonth: return 0
        case .NextWeek: return 1
        case .Tomorrow: return 2
        case .Lunch: return 3
        }
    }
    
    public static func fromInt(index: Int) -> Deadline {
        switch index {
        case 0: return .NextMonth
        case 1: return .NextWeek
        case 2: return .Tomorrow
        case 3: return .Lunch
        default: assert(false, "Unsupported enum index")
            return .NextMonth
        }
    }
}

public struct TaskEvent {
    public let task: Task
    public let action: TaskAction
    public let property: TaskProperty?
    public let oldValue: Any?
    public let newValue: Any?
    
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
    public var deadline: Deadline { didSet {
        self.notify(.Deadline, oldValue: oldValue, newValue: self.deadline)
        } }
    public var important: Bool { didSet {
        self.notify(.Important, oldValue: oldValue, newValue: self.important)
        } }

    init(id: NSUUID = NSUUID(), name: String = "", description: String = "", deadline: Deadline = .NextMonth, important: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.deadline = deadline
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
