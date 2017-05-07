//
//  EmployeeModel.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 06/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EmployeeModel {
    
    var employee: Employee!
    var managedObjectContext: ManagedObjectContext!
    var id: String!
    
    init(id: String? = nil, moc: ManagedObjectContext? = nil) {
        self.id = id
        self.managedObjectContext = moc
        if self.id == nil {
            let managedObjectContext = ManagedObjectContext.managedObjectContext()
            self.managedObjectContext = managedObjectContext
            employee = Employee.managedObject(managedObjectContext)
            employee.id = NSUUID().uuidString
            employee.updateTime = NSDate()
        } else {
            employee = Employee.employeeWithEmployeeID(employeeID: id!, managedObjectContext: moc!)
            employee.updateTime = NSDate()
        }
    }
}
