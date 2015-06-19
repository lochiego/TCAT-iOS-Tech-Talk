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

class TaskManagementTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTask() {
        let firstTask = TaskManager.sharedInstance.create()
        XCTAssertNotNil(firstTask.id, "ID is nil")
        XCTAssertNotNil(firstTask.name, "Name is nil")
        XCTAssertNotNil(firstTask.description, "Description is nil")
        XCTAssertTrue(firstTask.deadline == .NextMonth, "deadline is not nil")
        XCTAssertFalse(firstTask.important, "Important is true")
    }
    
    func testTaskManager() {
        let manager = TaskManager()
        
        let observer = TestObserver()
        manager.addListener(observer)
        
        XCTAssert(manager.fetchTasks().count == 0, "Rogue note present in task manager")
        var firstTask = manager.create()
        XCTAssert(manager.fetchTasks().count == 1, "Did not add task to list")
        
        firstTask.name = "Something"
        let updatedTask = manager.fetchTasks()[0]
        XCTAssert(updatedTask.name == "Something", "Failed to update property")
        
        manager.delete(updatedTask)
        XCTAssert(manager.fetchTasks().count == 0, "Failed to delete task properly")
        
        var sem = dispatch_semaphore_create(0)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            dispatch_semaphore_signal(sem)
        })
        dispatch_semaphore_wait(sem, dispatch_time(DISPATCH_TIME_NOW, 10))
        XCTAssert(observer.notices == 3, "Did not receive events")
    }
    
}

class TestObserver: TaskListener {
    var notices: Int = 0
    func notify(event: TaskEvent) {
        notices++
    }
}
