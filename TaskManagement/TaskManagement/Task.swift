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
import Argo
import Runes

// Task

public class Task: Note, Equatable {
    public let id: NSUUID
    public var name: String
    public var description: String
    public var deadline: NSDate?
    public var urgent: Bool
    public var important: Bool

    public init(id: NSUUID = NSUUID(), name: String = "", description: String = "", deadline: NSDate? = nil, urgent: Bool = false, important: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.deadline = deadline
        self.urgent = urgent
        self.important = important
    }
}

public func == (lhs: Task, rhs: Task) -> Bool {
    return lhs.id == rhs.id
}

extension Task: Decodable {
    static func create
        (id: NSUUID)
        (name: String)
        (description: String)
        (deadline: NSDate?)
        (urgent: Bool)
        (important: Bool)
    -> Task {
        let task = Task(id: id, name: name, description: description, deadline: deadline, urgent: urgent, important: important)
        return task
    }
    
    public static func decode(j: JSON) -> Decoded<Task> {
        return Task.create
            <^> j <| "id"
            <*> j <| "name"
            <*> j <| "description"
            <*> j <|? "deadline"
            <*> j <| "urgent"
            <*> j <| "important"
    }
}