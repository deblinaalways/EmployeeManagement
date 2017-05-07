//
//  ViewEmployeeDetails.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 07/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit

class ViewEmployeeDetails: UITableViewController, DidUpdateEmployeeViewModelDelegate {
    @IBOutlet var employeeImageView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var dob: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var hobbies: UILabel!
    
    private var model: EmployeeViewModel!
    private var moc: ManagedObjectContext!
    // MARK: Factory Method
    class func viewController(viewModel: EmployeeViewModel, moc: ManagedObjectContext) -> ViewEmployeeDetails {
        let vc = UIStoryboard.init(name: "Employee", bundle: nil).instantiateViewController(withIdentifier: "ViewEmployeeDetails") as! ViewEmployeeDetails
        vc.model = viewModel
        vc.moc = moc
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncEmployeeData(model: model)
    }
    
    private func syncEmployeeData(model: EmployeeViewModel) {
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
        self.tableView.reloadData()
    }
    
    @IBAction func editEmployeeDetailsButtonTapped(_ sender: UIBarButtonItem) {
        let editEmployeeProfileController = AddNewEmployeeTableViewController.viewController(employeeModel: model, moc: moc)
        editEmployeeProfileController.delegate = self
        self.navigationController?.pushViewController(editEmployeeProfileController, animated: true)
    }
    
    func didUpdateEmployee(employee: Employee) {
        let newModel = EmployeeViewModel(employee: employee)
        syncEmployeeData(model: newModel)
    }
    
}
