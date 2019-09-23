//
//  TaskDetailTableViewController.swift
//  TaskManager
//
//  Created by Manimurugan on 23/09/19.
//  Copyright © 2019 Manimurugan. All rights reserved.
//

import UIKit
import CoreData
class TaskDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var buttonAddTask: UIButton!
    @IBOutlet weak var textViewDetail: UITextView!
    @IBOutlet weak var textFieldTaskName: UITextField!
    var task: Task?
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = delegate.persistentContainer.viewContext
        
        if(task != nil){
            textFieldTaskName.text = task?.name
            textViewDetail.text = task?.detail
            if(task?.task_status == "stopped"){
                self.navigationItem.title = "Summary"
                buttonAddTask.isHidden = true
                textFieldTaskName.isUserInteractionEnabled = false
                textViewDetail.isUserInteractionEnabled = false
            }else{
                self.navigationItem.title = "Update Task"
                buttonAddTask.setTitle("Update Task", for: .normal)
            }
            
        }else{
            self.navigationItem.title = "Add New Task"
        }
        
        updateUI()
        addTapGesture()
    }
    
    func addTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outSideClicked))
        self.tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc func outSideClicked(){
        self.view.endEditing(true)
    }
    
    func updateUI(){
        textFieldTaskName.layer.cornerRadius = 4.0
        textFieldTaskName.layer.borderColor = UIColor.lightGray.cgColor
        textFieldTaskName.layer.borderWidth = 0.5
        
        textViewDetail.layer.cornerRadius = 4.0
        textViewDetail.layer.borderColor = UIColor.lightGray.cgColor
        textViewDetail.layer.borderWidth = 0.5
        
        textFieldTaskName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textFieldTaskName.leftViewMode = .always
        
        buttonAddTask.layer.cornerRadius = 4.0
    }
    
    @IBAction func taskClicked(_ sender: Any) {
        if(textFieldTaskName.text?.count == 0){
            showAlert(with: "Error", and: "Please enter task name")
        }else if(textViewDetail.text.count == 0){
            showAlert(with: "Error", and: "Please enter task detail")
        }else{
            if(task != nil){
                updateTask()
            }else{
                saveTask()
            }
        }
    }
    func updateTask(){
        task!.setValue(textFieldTaskName.text, forKey: "name")
        task!.setValue(textViewDetail.text, forKey: "detail")
        do {
            try task!.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveTask(){
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: self.managedObjectContext)
        let record = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
        record.setValue(textFieldTaskName.text, forKey: "name")
        record.setValue(textViewDetail.text, forKey: "detail")
        record.setValue(0, forKey: "duration")
        record.setValue(NSDate(), forKey: "createdAt")
        record.setValue("not_started", forKey: "task_status")
        do {
            try record.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(with title: String , and message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
