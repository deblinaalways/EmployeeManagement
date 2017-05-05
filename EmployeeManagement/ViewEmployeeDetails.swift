//
//  ViewEmployeeDetails.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 07/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit

class ViewEmployeeDetails: UITableViewController {
    @IBOutlet var employeeImageView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var dob: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var hobbies: UILabel!
    
    private(set) var model: EmployeeViewModel!
    // MARK: Factory Method
    class func viewController(viewModel: EmployeeViewModel) -> ViewEmployeeDetails {
        let vc = UIStoryboard.init(name: "Employee", bundle: nil).instantiateViewController(withIdentifier: "ViewEmployeeDetails") as! ViewEmployeeDetails
        vc.model = viewModel
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        employeeImageView.image = model.image
        name.text = model.name
        dob.text = model.dobString
        address.text = model.address
        gender.text = model.gender
        if model.hobbies.count > 0 {
            var text = ""
            model.hobbies.forEach {
                text = text + " " + $0
            }
            hobbies.text = text
        }
    }
    
    @IBAction func editEmployeeDetailsButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(AddNewEmployeeTableViewController.viewController(employeeModel: model), animated: true)
    }
    
}
