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

public class Task: Note, Equatable {
    public let id: NSUUID
    public var name: String
    public var description: String
    public var created: NSDate
    public var deadline: NSDate?
    public var urgent: Bool
    public var important: Bool

    public init(id: NSUUID = NSUUID(), name: String = "", description: String = "", deadline: NSDate? = nil, urgent: Bool = false, important: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.created = NSDate()
        self.deadline = deadline
        self.urgent = urgent
        self.important = important
    }
}

public func == (lhs: Task, rhs: Task) -> Bool {
    return lhs.id == rhs.id
}
