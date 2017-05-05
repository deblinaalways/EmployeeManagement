//
//  EmployeeViewModel.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 04/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EmployeeViewModel {
    
    private(set) var employee: Employee!
    
    //Initialize with employee model
    init(employee: Employee) {
        self.employee = employee
    }
    
    var id: String                { return employee.id! }
    var name: String              { return employee.name! }
    var gender: String            { return employee.gender! }
    var image: UIImage            { return UIImage(data: employee.image! as Data)! }
    var searchText: [String]        {
        var searchtext = [""]
        searchtext.append(name)
        searchtext.append(gender)
        searchtext.append(address)
        searchtext.append(designation)
        searchtext.append(dobString)
        searchtext.append(contentsOf: hobbies)
        return searchtext
    }
    
    //optional fields
    var updatedDateString: String {
        guard let updatedDate = employee.updateTime else {
            return Date().dateInYYYYMMDDFormat()
        }
        let dateString: String!
        if Date().dateOffset(date: updatedDate as Date)! > 7 {
            dateString = (updatedDate as Date).dateInYYYYMMDDFormat()
        } else {
            let today = weekDay(day: Date.dayOfWeek(dateString: Date().dateInYYYYMMDDFormat())!)
            let weekday = weekDay(day: Date.dayOfWeek(dateString: (updatedDate as Date).dateInYYYYMMDDFormat())!)
            dateString = today == weekday ? "Today" : weekday
        }
        return dateString
    }
    
    var address: String {
        guard let address = employee.address else { return "" }
        return address }
    
    var hobbies: [String] {
        guard let hobbies = employee.hobbies else { return [String]() }
        return hobbies as! [String] }
    
    var designation: String {
        guard let designation = employee.designation else { return "" }
        return designation
    }
    
    var dobString: String {
        guard let dob = employee.dob else { return "" }
        return (dob as Date).dateInYYYYMMDDFormat()
    }
    
    func weekDay(day: Int) -> String {
        switch day {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return ""
        }
    }
}
