//
//  EmployeeListModel.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 04/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum FetchOrder {
    case Name
    case UpdatedTime
    case Designation
    case Dob
}

class EmployeeListModel: NSObject, NSFetchedResultsControllerDelegate {
    
    private(set) var employeeList: NSFetchedResultsController<NSFetchRequestResult>!
    var managedObjectContext = ManagedObjectContext.managedObjectContext()
    
    // By default employee records are fetched by updatedDate
    func fetchEmployees(SortedBy sortOrder: FetchOrder) {
        
        switch sortOrder {
        case .Dob: employeeList = Employee.fetchedResultsController(managedObjectContext, sortKeys: ["dob"])
        case .Designation: employeeList = Employee.fetchedResultsController(managedObjectContext, sortKeys: ["designation"])
        case .Name: employeeList = Employee.fetchedResultsController(managedObjectContext, sortKeys: ["name"])
        default: employeeList = Employee.fetchedResultsController(managedObjectContext, sortKeys: ["updateTime"])
        }
    }
    
    func todaysRecordCount() -> Int {
        let employees = Employee.getManagedObjects(managedObjectContext) as! [Employee]
        let today = Date().dateInYYYYMMDDFormat()
        var recordCount = 0
        if employees != nil || employees.count > 0 {
            employees.forEach {
                if today.isEqual(($0.updateTime! as Date).dateInYYYYMMDDFormat()) {
                    recordCount = recordCount + 1
                }
            }
        }
        return recordCount
    }
    
    func fetchEmployees(By searchText: String) {
        employeeList = Employee.fetchedResultsController(managedObjectContext, sortKeys: ["updateTime"], predicate: NSPredicate(format: "searchText CONTAINS[c] %@", searchText.lowercased()), delegate: self)
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}
