//
//  TaskTableViewself.swift
//  TaskManager
//
//  Created by Manimurugan on 23/09/19.
//  Copyright © 2019 Manimurugan. All rights reserved.
//

import UIKit
import CoreData
class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var labelTaskDetail: UILabel!
    @IBOutlet weak var labelTaskName: UILabel!
    @IBOutlet weak var buttonPlayPause: UIButton!
    @IBOutlet weak var buttonStop: UIButton!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var stopWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var playWidthConstraints: NSLayoutConstraint!
    
    
    var taskPresenter: TaskPresenter?
    var task: Task?
    var managedObjectContext: NSManagedObjectContext!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = delegate.persistentContainer.viewContext
        buttonStop.addTarget(self, action: #selector(stopClicked), for: .touchUpInside)
        buttonPlayPause.addTarget(self, action: #selector(playPauseClicked), for: .touchUpInside)
        taskPresenter = TaskPresenter(cell: self)
    }
    
    func configureCell(task: Task) {
        self.task = task
        self.labelTaskName.text = task.name
        self.labelTaskDetail.text = task.detail
        if(task.task_status == "not_started"){
            self.stopWidthConstraints.constant = 0
            self.playWidthConstraints.constant = 23
            self.buttonPlayPause.layoutIfNeeded()
            self.buttonStop.layoutIfNeeded()
            self.buttonPlayPause.setImage(UIImage(named: "play"), for: .normal)
            self.labelStatus.text = "Not Started"
        }else if(task.task_status == "running"){
            self.stopWidthConstraints.constant = 23
            self.playWidthConstraints.constant = 23
            self.buttonPlayPause.layoutIfNeeded()
            self.buttonStop.layoutIfNeeded()
            self.buttonPlayPause.setImage(UIImage(named: "pause"), for: .normal)
            self.labelStatus.text = "Running"
        }else if(task.task_status == "paused"){
            self.stopWidthConstraints.constant = 23
            self.playWidthConstraints.constant = 23
            self.buttonPlayPause.layoutIfNeeded()
            self.buttonStop.layoutIfNeeded()
            self.buttonPlayPause.setImage(UIImage(named: "play"), for: .normal)
            self.labelStatus.text = "Paused"
            self.updateTimeStatus()
        }else{
            self.stopWidthConstraints.constant = 0
            self.playWidthConstraints.constant = 0
            self.buttonPlayPause.layoutIfNeeded()
            self.buttonStop.layoutIfNeeded()
            self.labelStatus.text = "Completed"
            
        }
        
    }
    
    func updateTimeStatus(){
        taskPresenter?.task = task
        taskPresenter?.updateTimer()
    }
    
    @objc func playPauseClicked(){
        if(task?.task_status == "running"){
            task?.task_status = "paused"
        }else{
            task?.task_status = "running"
        }
        do {
            try task!.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        taskPresenter?.updateTimer()
        
        
    }
    
    @objc func stopClicked(){
        task?.task_status = "stopped"
        do {
            try task!.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        taskPresenter?.updateTimer()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
