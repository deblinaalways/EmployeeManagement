//
//  EmployeeListTableViewController.swift
//  Kroud
//
//  Created by Deblina Das on 04/05/17.
//  Copyright © 2017 Kroud. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EmployeeListTableViewController: UIViewController {
    
    @IBOutlet var employeeCount: UILabel!
    @IBOutlet var todaysAddedCount: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var model =  EmployeeListModel()
    
    // MARK: Factory Method
    class func viewController() -> UINavigationController {
        return UIStoryboard.init(name: "Employee", bundle: nil).instantiateViewController(withIdentifier: "EmployeeListNavigationController") as! UINavigationController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.delegate = self
        fetchEmployeesAndReloadTable(sortedBy: .UpdatedTime)
    }
    
    // Fetch employee entity object from Employee Data Model and reloads the tableView with the updated employee list context
    func fetchEmployeesAndReloadTable(sortedBy: FetchOrder) {
        model.fetchEmployees(SortedBy: sortedBy)
        guard let totalEmployeeList = model.employeeList.fetchedObjects else { return }
        employeeCount.text = "\(totalEmployeeList.count)"
        todaysAddedCount.text = "Todays Report: \(model.todaysRecordCount())"
        self.tableView.reloadData()
    }
    
    @IBAction func addNewEmployeeButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(AddNewEmployeeTableViewController.viewController(), animated: true)
    }
    
    @IBAction func sortEmployeeButtonTapped(_ sender: UIButton) {
        let vc = SortOrderTableViewController.viewcontroller { (sortOrder) in
            if sortOrder != nil {
                print(sortOrder)
                DispatchQueue.main.async {
                    self.fetchEmployeesAndReloadTable(sortedBy: sortOrder)
                }
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

extension EmployeeListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.employeeList.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let employeeCell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeCell
        let employee = (model.employeeList.fetchedObjects as! [Employee])[indexPath.row]
        employeeCell.configure(with: EmployeeViewModel(employee: employee))
        return employeeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.model.employeeList.delegate = nil
        let employee = (model.employeeList.fetchedObjects as! [Employee])[indexPath.row]
        self.navigationController?.pushViewController(ViewEmployeeDetails.viewController(viewModel: EmployeeViewModel(employee: employee), moc: model.managedObjectContext), animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "delete" , handler: { (action: UITableViewRowAction!, indexPath: IndexPath!) in
            DispatchQueue.main.async {
                let employee = self.model.employeeList.object(at: indexPath) as! Employee
                self.model.managedObjectContext.delete(employee)
                try! self.model.managedObjectContext.save()
                self.model.fetchEmployees(SortedBy: .UpdatedTime)
                try! self.model.employeeList.performFetch()
                guard let totalEmployeeList = self.model.employeeList.fetchedObjects else { return }
                self.employeeCount.text = "\(totalEmployeeList.count)"
                self.tableView.reloadData()
            }
        })
        return [deleteAction]
    }
    
    func filterContentForSearchText(_ searchText: String) {
        model.fetchEmployees(By: searchText)
        tableView.reloadData()
    }
}

extension EmployeeListTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchString.isEmpty && searchString.characters.count >= 3 {
            filterContentForSearchText(searchString)
        } else if searchString.isEmpty {
            //Default
            fetchEmployeesAndReloadTable(sortedBy: .UpdatedTime)
        }
    }
}
