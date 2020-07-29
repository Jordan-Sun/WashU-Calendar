//
//  ViewController.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/28.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    var event: Event!
    var coreDataController: CoreDataController!
    
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = event.name
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd, EEEE")
        dateLabel.text = dateFormatter.string(from: event.start!)
        dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
        timeLabel.text = "\(dateFormatter.string(from: event.start!)) - \(dateFormatter.string(from: event.end!))"
        if let days = event.section?.days {
            repeatLabel.text = "Repeats on "
            repeatLabel.text?.append(contentsOf: (days[days.index(days.startIndex, offsetBy: 6)] != "-") ? "Sunday, " : "")
            repeatLabel.text?.append(contentsOf: (days[days.index(days.startIndex, offsetBy: 0)] != "-") ? "Monday, " : "")
            repeatLabel.text?.append(contentsOf: (days[days.index(days.startIndex, offsetBy: 1)] != "-") ? "Tuesday, " : "")
            repeatLabel.text?.append(contentsOf: (days[days.index(days.startIndex, offsetBy: 2)] != "-") ? "Wednesday, " : "")
            repeatLabel.text?.append(contentsOf: (days[days.index(days.startIndex, offsetBy: 3)] != "-") ? "Thursday, " : "")
            repeatLabel.text?.append(contentsOf: (days[days.index(days.startIndex, offsetBy: 4)] != "-") ? "Friday, " : "")
            repeatLabel.text?.append(contentsOf: (days[days.index(days.startIndex, offsetBy: 5)] != "-") ? "Saturday, " : "")
            let _ = repeatLabel.text?.popLast()
            let _ = repeatLabel.text?.popLast()
            repeatLabel.text?.append(".")
            repeatLabel.isHidden = false
        } else {
            repeatLabel.isHidden = true
        }
        locationLabel.text = event.location
        if let desc = event.section?.desc {
            descriptionLabel.text = desc
            descriptionLabel.textColor = .label
        } else {
            descriptionLabel.text = "No descriptions available."
            descriptionLabel.textColor = .secondarySystemFill
        }
        
        eventView.backgroundColor = (event.color as? UIColor) ?? .secondarySystemBackground
        
    }

    @IBAction func deleteEvent(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Are you sure to delete this event?", message: nil, preferredStyle: .actionSheet)
        
        let deleteEventAction = UIAlertAction(title: "Delete this event", style: .destructive, handler: {
            action in
            self.coreDataController.deleteFromCoreData(self.event)
            let _ = self.navigationController?.popViewController(animated: true)
        })
        actionSheet.addAction(deleteEventAction)
        
        if let section = event.section {
            let courseListingAction = UIAlertAction(title: "Delete ALL events in this section", style: .destructive, handler: {
                action in
                self.coreDataController.deleteFromCoreData(section)
                let _ = self.navigationController?.popViewController(animated: true)
            })
            actionSheet.addAction(courseListingAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
