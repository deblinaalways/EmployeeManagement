//
//  HobbiesTableViewController.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 04/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit

protocol DidUpdateHobiesDelegate {
    func didUpdateHobbies(hobbies: [String])
}
class HobbiesTableViewController: UITableViewController {
    
    @IBOutlet var doneButton: UIBarButtonItem!
    private(set) var selectedHobby = [String]()
    private var hobbyList: [String] = ["Cricket", "Football", "Coding", "Reading", "Listening Music", "Watching Movies", "Swimming", "Other"]
    var delegate: DidUpdateHobiesDelegate!
    
    // MARK: Factory Method
    class func viewController() -> HobbiesTableViewController {
        return UIStoryboard.init(name: "Employee", bundle: nil).instantiateViewController(withIdentifier: "HobbiesTableViewController") as! HobbiesTableViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        doneButton.isEnabled = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return hobbyList.count }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 44 }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hobby", for: indexPath)
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell.accessoryType = rowIsSelected ? .checkmark : .none
        cell.textLabel?.text = hobbyList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doneButton.isEnabled = true
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.indexPathsForSelectedRows == nil { doneButton.isEnabled = false }
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    @IBAction func selectHobbiesAndPopViewController(_ sender: UIBarButtonItem) {
        let selectedRows = self.tableView.indexPathsForSelectedRows
        if (selectedRows?.count)! > 0 {
            selectedRows?.forEach {
                self.selectedHobby.append(hobbyList[$0.row])
            }
        }
        delegate.didUpdateHobbies(hobbies: self.selectedHobby)
        self.navigationController?.popViewController(animated: true)
    }
    
}
