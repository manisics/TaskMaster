//
//  Task+CoreDataProperties.swift
//  TaskManager
//
//  Created by Manimurugan on 23/09/19.
//  Copyright © 2019 Manimurugan. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var detail: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var duration: Int64
    @NSManaged public var task_status: String?

}
