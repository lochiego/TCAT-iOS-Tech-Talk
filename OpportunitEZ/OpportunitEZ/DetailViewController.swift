//
//  DetailViewController.swift
//  OpportunitEZ
//
//  Created by Eric Gonzalez on 6/19/15.
//  Copyright (c) 2015 Texas A&M Engineering Experiment Station. All rights reserved.
//

import UIKit
import TaskManagement

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var importantSeg: UISegmentedControl!
    @IBOutlet weak var deadlineSeg: UISegmentedControl!
    @IBOutlet weak var descriptionField: UITextView!
    
    weak var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let recognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        self.view.addGestureRecognizer(recognizer)
        
        configureControls()
        
        populateControls()
    }
    
    func configureControls() {
        nameField.delegate = self
        nameField.addTarget(self, action: Selector("nameChanged"), forControlEvents: .EditingChanged)
        importantSeg.addTarget(self, action: Selector("segChanged:"), forControlEvents: .ValueChanged)
        deadlineSeg.addTarget(self, action: Selector("segChanged:"), forControlEvents: .ValueChanged)
        descriptionField.delegate = self
    }
    
    func populateControls() {
        nameField.text = task.name
        descriptionField.text = task.description
        importantSeg.selectedSegmentIndex = task.important ? 0 : 1
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            deadlineSeg.setTitle(nextMonthCode, forSegmentAtIndex: 0)
            deadlineSeg.setTitle(nextWeekCode, forSegmentAtIndex: 1)
            deadlineSeg.setTitle(tomorrowCode, forSegmentAtIndex: 2)
            deadlineSeg.setTitle(lunchCode, forSegmentAtIndex: 3)
        }
        deadlineSeg.selectedSegmentIndex = task.deadline.intValue()
    }
    
    func dismissKeyboard() {
        nameField.resignFirstResponder()
        descriptionField.resignFirstResponder()
    }
    
    // Update name
    
    func nameChanged() {
        task.name = nameField.text
    }
    
    // Update Important or Urgent
    
    func segChanged(sender: UISegmentedControl) {
        dismissKeyboard()
        
        if (sender === importantSeg) {
            task.important = !task.important
        }
        else {
            task.deadline = Deadline.fromInt(deadlineSeg.selectedSegmentIndex)
        }
    }
    
    // Text View Delegate
    
    func textViewDidChange(textView: UITextView) {
        task.description = textView.text
    }

}
