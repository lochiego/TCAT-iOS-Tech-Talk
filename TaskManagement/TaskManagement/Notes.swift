//
//  Notes.swift
//  TaskManagement
//
//  Created by Eric Gonzalez on 6/3/15.
//  Copyright (c) 2015 Texas A&M Engineering Experiment Station. All rights reserved.
//

import Foundation

public protocol Note {
    var name: String { get }
    var description: String { get }
    var created: NSDate { get }
}

public struct Reminder: Note {
    public var name: String
    public var description: String
    public var created: NSDate
    public var deadline: NSDate
    public var alarm: NSDate?
    
    public init(name: String, description: String, created: NSDate = NSDate(), deadline: NSDate, alarm: NSDate? = nil)
    {
        self.name = name
        self.description = description
        self.created = created
        self.deadline = deadline
        self.alarm = alarm
    }

}
