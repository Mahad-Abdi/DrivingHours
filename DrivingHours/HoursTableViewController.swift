//
//  HoursTableViewController.swift
//  DrivingHours
//
//  Created by Mahad Abdi on 5/2/22.
//

import UIKit

class HoursTableViewController: UITableViewController {
    
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    var startTimeItem: UIDatePicker!
    var dateItem: Hour!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dateItem == nil {
            dateItem = Hour(date: "", startTime: Date(), endTime: Date(), notes: "")
        }
        date.text = dateItem.date
        startTime.date = dateItem.startTime
        endTime.date = dateItem.endTime
        noteView.text = dateItem.notes

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dateItem = Hour(date: date.text!, startTime: startTime.date, endTime: endTime.date, notes: noteView.text)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    

       

}
