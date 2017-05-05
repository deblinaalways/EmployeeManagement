//
//  EmployeeCell.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 04/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit

class EmployeeCell: UITableViewCell {
    

    @IBOutlet var employeeImageView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var dob: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var updateDate: UILabel!
    
    private(set) var employeeViewModel: EmployeeViewModel!
    
    func configure(with employeeViewModel: EmployeeViewModel) {
        self.employeeViewModel = employeeViewModel
        employeeImageView.image = self.employeeViewModel.image
        name.text = self.employeeViewModel.name
        dob.text = self.employeeViewModel.dobString
        gender.text = self.employeeViewModel.gender
        updateDate.text = self.employeeViewModel.updatedDateString
    }
}
