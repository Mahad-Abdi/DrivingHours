//
//  ViewController.swift
//  DrivingHours
//
//  Created by Mahad Abdi on 5/2/22.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    @IBOutlet weak var totalDrivingHours: UILabel!
    @IBOutlet weak var drivingHoursRemaining: UILabel!
    
    
    var hours : [Hour] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        updateTime()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! HoursTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.dateItem = hours[selectedIndexPath.row]
        }
        else {
            if let selectedindexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedindexPath, animated: true)
            }
        }
        updateTime()
    }
    
    
    func calculateTimePassed(start: Date, end: Date) -> Double  {
        let difference = end.timeIntervalSince(start)
        let hours = difference / 3600
        let minutes = (difference - hours * 3600) * 60
        return Double(hours + (minutes / 60))
    }
    
    func updateTime() {
        var totalTime = 0.0
        for Hour in hours {
            totalTime += calculateTimePassed(start: Hour.startTime, end: Hour.endTime)
            if totalTime >= 40 {
                var strTotalDrivingHours = String(format:"%.2f", totalTime)
                totalDrivingHours.text = String(" \(strTotalDrivingHours) hours")
                drivingHoursRemaining.text = "Good luck on the exam!"
            }
            else {
                var strTotalDrivingHours = String(format:"%.2f", totalTime)
                totalDrivingHours.text = String(" \(strTotalDrivingHours) hours")
                var remainingHours = 40.0 - totalTime
                var strRemainingHours = String(format:"%.2f", remainingHours)
                drivingHoursRemaining.text = "\(strRemainingHours) hours"
            }
        }
        
    }
    
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos")
            .appendingPathExtension("json")
         
        guard let data = try? Data(contentsOf:documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            hours = try jsonDecoder.decode(Array<Hour>.self, from: data)
            tableView.reloadData()
        } catch {
            print("Error could not load data\(error.localizedDescription)")
        }
        updateTime()
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos")
            .appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(hours)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("ERROR: Could not save data \(error.localizedDescription)")
        }
        updateTime()
        
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! HoursTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            hours[selectedIndexPath.row] = source.dateItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: hours.count, section: 0)
            hours.append(source.dateItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
         }
        saveData()
        updateTime()
    }
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
        updateTime()
    }
    


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = hours[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            hours.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateTime()
            saveData()
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = hours[sourceIndexPath.row]
        hours.remove(at: sourceIndexPath.row)
        hours.insert(itemToMove, at: destinationIndexPath.row)
         saveData()
        updateTime()

    }

    
    
    
}


