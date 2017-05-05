//
//  AddNewEmployeeTableViewController.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 04/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit

class AddNewEmployeeTableViewController: UITableViewController, DidUpdateHobiesDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var employeeImageView: UIImageView!
    @IBOutlet var name: UITextField!
    @IBOutlet var designation: UITextField!
    @IBOutlet var dob: UITextField!
    @IBOutlet var address: UITextView!
    @IBOutlet var gender: UITextField!
    @IBOutlet var hobbyList: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var genderPicker: UIPickerView!
    @IBOutlet var toolBar: UIToolbar!
    
    private var genderArray = ["male", "female", "other"]
    private var model = EmployeeModel()
    private var employeeModel: EmployeeViewModel!
    var imageSelected = false
    
    // MARK: Factory Method
    class func viewController(employeeModel: EmployeeViewModel? = nil) -> AddNewEmployeeTableViewController {
        let vc = UIStoryboard.init(name: "Employee", bundle: nil).instantiateViewController(withIdentifier: "AddNewEmployeeTableViewController") as! AddNewEmployeeTableViewController
        vc.employeeModel = employeeModel
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.estimatedRowHeight = 89
        genderPicker.delegate = self
        genderPicker.dataSource = self
        selectedDate = datePicker.date
        dob.inputView = datePicker
        dob.inputAccessoryView = toolBar
        gender.inputView = genderPicker
        gender.inputAccessoryView = toolBar
        if employeeModel != nil {
            //To be Edited
            pasteEmployeeData()
        }
    }
    
    private func pasteEmployeeData() {
        employeeImageView.image = employeeModel.image
        name.text = employeeModel.name
        designation.text = employeeModel.designation
        dob.text = employeeModel.dobString
        address.text = employeeModel.address
        gender.text = employeeModel.gender
        if employeeModel.hobbies.count > 0 {
            var text = ""
            employeeModel.hobbies.forEach {
                text = text + " " + $0
            }
            hobbyList.text = text
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            let hobbiesTableViewController = HobbiesTableViewController.viewController()
            hobbiesTableViewController.delegate = self
            self.navigationController?.pushViewController(hobbiesTableViewController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: Select Multiple hobbies delegate
    func didUpdateHobbies(hobbies: [String]) {
        if hobbies.count > 0 {
            var text = ""
            hobbies.forEach {
                text = text + " " + $0
            }
            hobbyList.text = text
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return UIScreen.main.bounds.height * 0.05
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genderArray[row]
    }

    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        name.resignFirstResponder()
        designation.resignFirstResponder()
        address.resignFirstResponder()
    }

    var selectedDate: Date!
    var selectedGender: String!
    @IBAction func dobPicked(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        name.resignFirstResponder()
        designation.resignFirstResponder()
        address.resignFirstResponder()
        dob.resignFirstResponder()
        gender.resignFirstResponder()
    }
    @IBAction func rowSelected(_ sender: UIBarButtonItem) {
        if dob.isFirstResponder {
            dob.text = selectedDate.dateInYYYYMMDDFormat()
            dob.resignFirstResponder()
        } else if gender.isFirstResponder {
            guard let selectedGender = selectedGender else { return }
            gender.text = selectedGender
            gender.resignFirstResponder()
        }
    }
    @IBAction func changeImageButtonTapped(_ sender: UIButton) {
        uploadProfilePicture()
    }
    
    @IBAction func addNewEmployee(_ sender: UIBarButtonItem) {
        if isVerified() {
            if employeeModel == nil {
                saveToCoreData(with: model)
            } else {
                //Edited
                let existingEmployeeModel = EmployeeModel(id: employeeModel.id)
                if existingEmployeeModel.employee != nil {
                    saveToCoreData(with: existingEmployeeModel)
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func isVerified() -> Bool {
        if name.text!.isEmpty {
            AlertController.present(title: "Name", message: "Enter employee name.")
            return false }
        else if !imageSelected {
            AlertController.present(title: "Profile Image", message: "Select employee profile image.")
            return false
        } else if gender.text!.isEmpty {
            AlertController.present(title: "Gender", message: "Select gender.")
            return false
        }
        return true
    }
    
    private func saveToCoreData(with model: EmployeeModel) {
        var searchText = [""]
        model.employee.name = name.text
        searchText.append(name.text!.lowercased())
        guard let imageData = UIImageJPEGRepresentation(employeeImageView.image!, 1) else {
            print("Error in saving image")
            return
        }
        model.employee.image = imageData as NSData
        if designation.text != nil { model.employee.designation = designation.text }
        searchText.append(designation.text!.lowercased())
        model.employee.dob = selectedDate! as NSDate
        searchText.append((selectedDate!).dateInYYYYMMDDFormat())
        if address.text != nil {
            model.employee.address = address.text
            searchText.append(address.text!.lowercased())
        }
        model.employee.gender = gender.text
        searchText.append(gender.text!)
        if hobbyList.text != nil {
            var hobbyComponents = hobbyList.text?.components(separatedBy: .whitespaces)
            for (index, hobby) in (hobbyComponents?.enumerated())! {
                if hobby.isEmpty {
                    hobbyComponents?.remove(at: index)
                }
            }
            model.employee.hobbies = hobbyComponents! as NSObject
            var hobbies = [String]()
            hobbyComponents?.forEach { hobbies.append($0.lowercased()) }
            searchText.append(contentsOf: hobbies)
        }
        model.employee.searchText = searchText as NSObject
        print(model.employee)
        try! model.employee.managedObjectContext?.save()
    }
    
}
