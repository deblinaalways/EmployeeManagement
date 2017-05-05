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
    var managedObjectContext = ManagedObjectContext.managedObjectContext()
    var id: String!
    
    init(id: String? = nil) {
        self.id = id
        if self.id == nil {
            employee = Employee.managedObject(managedObjectContext)
            employee.id = NSUUID().uuidString
            employee.updateTime = NSDate()
        } else {
            employee = Employee.employeeWithEmployeeID(employeeID: id!, managedObjectContext: managedObjectContext)
            employee.updateTime = NSDate()
        }
    }
}
