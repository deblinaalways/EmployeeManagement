//
//  Employee.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 06/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import CoreData

extension Employee {
    
    class func employeeWithEmployeeID(employeeID: String, managedObjectContext: NSManagedObjectContext) -> Employee? {
        return Employee.getManagedObjects(managedObjectContext, predicate: NSPredicate(format: "id = %@", employeeID)).first as? Employee
    }
}
