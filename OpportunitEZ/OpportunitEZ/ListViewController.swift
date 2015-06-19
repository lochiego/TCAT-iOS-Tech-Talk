//
//  ListViewController.swift
//  OpportunitEZ
//
//  Created by Eric Gonzalez on 6/19/15.
//  Copyright (c) 2015 Texas A&M Engineering Experiment Station. All rights reserved.
//

import UIKit
import TaskManagement

let lunchCode = "\u{1F480}"
let tomorrowCode = "\u{1F4A3}"
let nextWeekCode = "\u{231B}"
let nextMonthCode = "\u{1F4A4}"

class ListViewController: UITableViewController, TaskListener {

    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private var hpTasks: [Task] = []
    private var lpTasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let mgr = TaskManager.sharedInstance
        for task in mgr.fetchTasks() {
            if (task.important) {
                hpTasks.append(task)
            }
            else {
                lpTasks.append(task)
            }
        }
        
        hpTasks.sort(sortFunction)
        lpTasks.sort(sortFunction)
        
        mgr.addListener(self)
		
        var firstTask = mgr.create()
        dispatch_async(dispatch_get_main_queue(), {
            firstTask.name = "Tech Talk"
            firstTask.description = "Develop an app over some \u{1F355}"
            firstTask.important = true
            firstTask.deadline = .Lunch
        })
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Important" : "Unimportant"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? hpTasks.count : lpTasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("defaultCell", forIndexPath: indexPath) as! OpportunityCell

        let task = indexPath.section == 0 ? hpTasks[indexPath.row] : lpTasks[indexPath.row]
        cell.nameLabel.text = task.name
        cell.detailLabel.text = task.description
        switch task.deadline {
        case .NextMonth: cell.iconLabel.text = nextMonthCode
        case .NextWeek: cell.iconLabel.text = nextWeekCode
        case .Tomorrow: cell.iconLabel.text = tomorrowCode
        case .Lunch: cell.iconLabel.text = lunchCode
        }

        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let destination = segue.destinationViewController as! DetailViewController
        var task: Task? = nil
        if (segue.identifier == "add") {
            task = TaskManager.sharedInstance.create()
        }
        else if let index = self.tableView.indexPathForSelectedRow() {
            task = index.section == 0 ? hpTasks[index.row] : lpTasks[index.row]
        }
        else {
            assert(false, "Task should not have been selected")
        }
        
        destination.task = task
    }


    // MARK: - Task Listener

    func notify(event: TaskEvent) {
        dispatch_async(dispatch_get_main_queue(), {
            switch event.action {
            case .Created:
                self.lpTasks.append(event.task)
                let paths = [NSIndexPath(forRow: self.lpTasks.count - 1, inSection: 1)]
                self.tableView?.insertRowsAtIndexPaths(paths, withRowAnimation: .Automatic)
            case .Updated:
                if event.property == .Important {
                    let task = event.task
                    if event.newValue as! Bool == true {
                        let index = find(self.lpTasks, task)!
                        self.lpTasks.removeAtIndex(index)
                        self.hpTasks.append(task)
                    }
                    else {
                        let index = find(self.hpTasks, task)!
                        self.hpTasks.removeAtIndex(index)
                        self.lpTasks.append(task)
                    }
                }
                self.hpTasks.sort(sortFunction)
                self.lpTasks.sort(sortFunction)
                self.tableView.reloadData()
            case .Deleted:
                if let index = find(self.hpTasks, event.task) {
                    self.hpTasks.removeAtIndex(index)
                    self.tableView?.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
                }
                else if let index = find(self.lpTasks, event.task) {
                    self.lpTasks.removeAtIndex(index)
                    self.tableView?.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 1)], withRowAnimation: .Automatic)
                }
            }
        })
    }
}

func sortFunction(t1: Task, t2: Task) -> Bool {
    return t1.deadline.intValue() > t2.deadline.intValue()
   
}