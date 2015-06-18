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
    public let id: String
    public var name: String
    public var description: String
    public let created: NSDate
    public var deadline: NSDate?
    public var urgent: Bool
    public var important: Bool

    public init(id: String = NSUUID().UUIDString, name: String = "", description: String = "", deadline: NSDate? = nil, urgent: Bool = false, important: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.created = NSDate()
        self.deadline = deadline
        self.urgent = urgent
        self.important = important
    }
    
    init(taskDict: Dictionary<String,Any>)
    {
        self.id = taskDict[Constants.Task.ID]! as! String
        self.name = taskDict[Constants.Task.NAME]! as! String
        self.description = taskDict[Constants.Task.DESCRIPTION]! as! String
        self.created = taskDict[Constants.Task.CREATED]! as! NSDate
        self.deadline = taskDict[Constants.Task.DEADLINE] as! NSDate?
        self.urgent = taskDict[Constants.Task.URGENT]! as! Bool
        self.important = taskDict[Constants.Task.IMPORTANT]! as! Bool
    }
    
    func toDictionary() -> Dictionary<String, Any>
    {
        var dict = [
            Constants.Task.ID : self.id,
            Constants.Task.NAME : self.name,
            Constants.Task.DESCRIPTION : self.description,
            Constants.Task.CREATED : self.created,
            Constants.Task.DEADLINE : self.deadline,
            Constants.Task.URGENT : self.urgent,
            Constants.Task.IMPORTANT : self.important
        ] as Dictionary<String, Any>
        
        if self.deadline != nil {
            dict[Constants.Task.DEADLINE] = deadline!
        }
        
        return dict
    }
}

public func == (lhs: Task, rhs: Task) -> Bool {
    return lhs.id == rhs.id
}

extension Task: Decodable {
    static func create
        (id: String)
        (name: String)
        (description: String)
        (created: NSDate)
        (deadline: NSDate?)
        (urgent: Bool)
        (important: Bool)
    -> Task {
        var taskDict = ["id" : id, "name" : name, "description" : description, "created" : created, "urgent" : urgent, "important" : important] //as Dictionary<String, Any>
        if deadline != nil {
            taskDict["deadline"] = deadline
        }
        let task = Task(taskDict: taskDict)
        return task
    }
    
    public static func decode(j: JSON) -> Decoded<Task> {
        return Task.create
            <^> j <| "id"
            <*> j <| "name"
            <*> j <| "description"
            <*> j <| "created"
            <*> j <|? "deadline"
            <*> j <| "urgent"
            <*> j <| "important"
    }
}