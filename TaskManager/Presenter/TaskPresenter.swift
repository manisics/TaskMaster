//
//  TaskPresenter.swift
//  TaskManager
//
//  Created by Manimurugan on 23/09/19.
//  Copyright © 2019 Manimurugan. All rights reserved.
//

import UIKit
import CoreData
class TaskPresenter: NSObject {
    
    var task: Task?
    var cell: TaskTableViewCell?
    var timer: Timer?
    var managedObjectContext: NSManagedObjectContext!
    
    init( cell: TaskTableViewCell) {
        super.init()
        self.cell = cell
        let delegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = delegate.persistentContainer.viewContext
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int64) -> String {
        return "\(String(format: "%02d", seconds / 3600)):\(String(format: "%02d", (seconds % 3600) / 60)):\(String(format: "%02d", (seconds % 3600) % 60))"
    }
    
    func updateTimer(){
        if(timer != nil){
            timer!.invalidate()
            timer = nil
        }
        self.cell?.labelTimer.isHidden = true
        
        if(task?.task_status == "running"){
            self.cell?.labelTimer.isHidden = false
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }else if(task?.task_status == "paused"){
            self.cell?.labelTimer.isHidden = false
            self.cell?.labelTimer.text = secondsToHoursMinutesSeconds(seconds: self.task!.duration)
        }
        
    }
    
    @objc  func update(){
        self.task?.duration = self.task!.duration + 1
        self.cell?.labelTimer.isHidden = false
        self.cell?.labelTimer.text = secondsToHoursMinutesSeconds(seconds: self.task!.duration)
        do {
            try self.task!.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
    }
    
    
    
    
    
}
