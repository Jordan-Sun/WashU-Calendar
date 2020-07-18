//
//  ViewController.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/17.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var appDelegate = UIApplication.shared.delegate as!  AppDelegate
    private var context = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext
    
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load course data after the view appears.
        do {
            courses = try context.fetch(Course.fetchRequest())
            for course in courses {
                print(course.name ?? "nil")
            }
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    //Debug functions
    
    @IBAction func addRandomCourse(_ sender: Any) {
        addCourseToCoreData(name: "Test Course", id: "000")
    }
    
}

