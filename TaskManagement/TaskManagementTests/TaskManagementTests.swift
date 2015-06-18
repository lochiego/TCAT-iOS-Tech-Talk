//
//  TaskManagementTests.swift
//  TaskManagementTests
//
//  Created by Eric Gonzalez on 6/3/15.
//  Copyright (c) 2015 Texas A&M Engineering Experiment Station. All rights reserved.
//

import UIKit
import XCTest
import TaskManagement
import Argo

extension Task {
    func toDictionary() -> Dictionary<String, Any>
    {
        var dict = [
            "id" : self.id,
            "name" : self.name,
            "description" : self.description,
            "created" : self.created,
            "deadline" : self.deadline,
            "urgent" : self.urgent,
            "important" : self.important
            ] as Dictionary<String, Any>
        
        if self.deadline != nil {
            dict["deadline"] = deadline!
        }
        
        return dict
    }
}

class TaskManagementTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReminder() {
        let futureDate = NSDate()
        var reminderTest = Reminder(name: "Dinner", description: "Chick-Fil-A tonight!", deadline:futureDate)
        
        XCTAssert(reminderTest.name == "Dinner", "Name not set")
        XCTAssert(reminderTest.description == "Chick-Fil-A tonight!", "Description not set")
        XCTAssert(reminderTest.deadline == futureDate, "Deadline not set")
        XCTAssertNil(reminderTest.alarm, "Default alarm failed")
        
        
        reminderTest = Reminder(name: "Dinner", description: "Chick-Fil-A tonight!", deadline:futureDate, alarm: NSDate())
        XCTAssert(reminderTest.name == "Dinner", "Default initializer failed")
        
        XCTAssert(reminderTest.name == "Dinner", "Default initializer failed")
        XCTAssert(reminderTest.description == "Chick-Fil-A tonight!", "Description not set")
        XCTAssert(reminderTest.deadline == futureDate, "Deadline not set")
        XCTAssertNotNil(reminderTest.alarm, "Alarm not set")
    }
    
    func testTask() {
        let firstTask = Task()
        XCTAssertNotNil(firstTask.id, "ID is nil")
        XCTAssertNotNil(firstTask.name, "Name is nil")
        XCTAssertNotNil(firstTask.description, "Description is nil")
        XCTAssertNotNil(firstTask.created, "created is nil")
        XCTAssertNil(firstTask.deadline, "deadline is not nil")
        XCTAssertNotNil(firstTask.urgent, "Urgent is nil")
        XCTAssertNotNil(firstTask.important, "Important is nil")
        
        let taskDict = firstTask.toDictionary()
//        XCTAssertNotNil(taskDict[Constants.Task.ID])
        
    }
    
    func testTaskManager() {
        let manager = TaskManager()
        
        let observer = TestObserver()
        manager.addListener(observer)
        
        XCTAssert(manager.fetchNotes().count == 0, "Rogue note present in task manager")
        let firstTask = manager.create()
        
        XCTAssert(manager.fetchNotes().count == 1, "Did not add task to list")
        
        manager.updateProperty(firstTask, property: "name", value: "Something")
        let updatedTask = manager.fetchNotes()[0]
        XCTAssert(updatedTask.name == "Something", "Failed to update property")
        
        manager.delete(updatedTask)
        XCTAssert(manager.fetchNotes().count == 0, "Failed to delete task properly")
        
        var sem = dispatch_semaphore_create(0)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            dispatch_semaphore_signal(sem)
        })
        dispatch_semaphore_wait(sem, dispatch_time(DISPATCH_TIME_NOW, 10))
        XCTAssert(observer.notices == 3, "Did not receive events")
    }
    
    func testSerialize() {
        var orig = Task(name: "A Task", description: "Something", urgent: false, important: false)
        var data = Serialize.toJson(orig)
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
        XCTAssertNotNil(json, "Did not decode json")
        if let j: AnyObject = json {
            let task: Decoded<Task> = decode(j)
            XCTAssertNotNil(task.value, "Did not deserialize json")
        }
    }
}

class TestObserver: NoteEventListener {
    var notices: Int = 0
    func notify(event: NoteEvent) {
        notices++
    }
}
