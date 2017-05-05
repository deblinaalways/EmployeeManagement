//
//  SortOrderTableViewController.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 07/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit

class SortOrderTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    let sortList = ["Added Date", "Date of birth", "Designation", "Name"]
    var completion: ((_ sortOrder: FetchOrder) -> Void)?
    
    class func viewcontroller(completion: ((_ sortOrder: FetchOrder) -> Void)?) -> SortOrderTableViewController {
        let vc  = UIStoryboard.init(name: "Employee", bundle: nil).instantiateViewController(withIdentifier: "SortOrderTableViewController") as! SortOrderTableViewController
        vc.completion = completion
        return vc
    }
    
//    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "sortCell", for: indexPath)
        cell.textLabel?.text = sortList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: completion!(.UpdatedTime)
        case 1: completion!(.Dob)
        case 2: completion!(.Designation)
        case 3: completion!(.Name)
        default: completion!(.UpdatedTime)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
