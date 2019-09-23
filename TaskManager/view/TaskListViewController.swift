//
//  TaskListViewController.swift
//  TaskManager
//
//  Created by Manimurugan on 23/09/19.
//  Copyright © 2019 Manimurugan. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet
class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableviewTask: UITableView!
    
    let reuseIdentifierToDoCell = "KTaskCell"
    
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = delegate.persistentContainer.viewContext
        configureData()
        configureNavigationButtons()
        self.tableviewTask.tableFooterView = UIView()
        self.tableviewTask.emptyDataSetSource = self
        self.tableviewTask.emptyDataSetDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func configureNavigationButtons(){
        let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addClicked))
        self.navigationItem.rightBarButtonItem = add
    }
    
    func configureData(){
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
  
    
    @objc func addClicked(){
        let taskDetail = self.storyboard?.instantiateViewController(withIdentifier: "KStoryIDTaskDetail") as! TaskDetailTableViewController
        self.navigationController?.pushViewController(taskDetail, animated: true)
    }
    
    
    
}

extension TaskListViewController: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierToDoCell, for: indexPath) as! TaskTableViewCell
        let task: Task = fetchedResultsController.object(at: indexPath as IndexPath) as! Task
        cell.configureCell(task: task)
        cell.updateTimeStatus()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task: Task = fetchedResultsController.object(at: indexPath as IndexPath) as! Task
        let taskDetail = self.storyboard?.instantiateViewController(withIdentifier: "KStoryIDTaskDetail") as! TaskDetailTableViewController
        taskDetail.task = task
        self.navigationController?.pushViewController(taskDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            let record: Task = fetchedResultsController.object(at: indexPath as IndexPath) as! Task
            managedObjectContext.delete(record)
            do {
                try managedObjectContext.save()
            } catch {
                let saveError = error as NSError
                print("\(saveError), \(saveError.userInfo)")
            }
        }
    }
}



extension TaskListViewController : NSFetchedResultsControllerDelegate{
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableviewTask.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableviewTask.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableviewTask.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableviewTask.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                if let cell = tableviewTask.cellForRow(at: indexPath) as? TaskTableViewCell{
                    let task: Task = fetchedResultsController.object(at: indexPath as IndexPath) as! Task
                    cell.configureCell(task: task)
                }
               
                
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableviewTask.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableviewTask.insertRows(at: [newIndexPath], with: .fade)
            }
            break
            
        @unknown default: break
            
        }
    }
}


extension TaskListViewController : DZNEmptyDataSetSource , DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty")!
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributedString = NSMutableAttributedString(string:"No Task")
        return attributedString
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributedString = NSMutableAttributedString(string:"Please click + icon on top to create new task")
        return attributedString
    }
    
}
