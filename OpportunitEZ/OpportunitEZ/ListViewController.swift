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
    
    private var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        TaskManager.sharedInstance.addListener(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("defaultCell", forIndexPath: indexPath) as! OpportunityCell

        let task = tasks[indexPath.row]
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
        else if let index = self.tableView.indexPathForSelectedRow()?.row {
            task = tasks[index]
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
                self.tasks.append(event.task)
                let paths = [NSIndexPath(forRow: self.tasks.count - 1, inSection: 0)]
                self.tableView?.insertRowsAtIndexPaths(paths, withRowAnimation: .Automatic)
            case .Updated:
                let index = find(self.tasks, event.task)!
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
            case .Deleted:
                let index = find(self.tasks, event.task)!
                self.tasks.removeAtIndex(index)
                self.tableView?.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
            }
        })
    }
}
