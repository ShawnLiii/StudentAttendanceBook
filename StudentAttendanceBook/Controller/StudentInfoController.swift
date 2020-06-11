//
//  StudentInfoController.swift
//  StudentAttendanceBook
//
//  Created by Shawn Li on 6/6/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class StudentInfoController: UIViewController
{
    var fName: String?
    var lName: String?
    var degree: String?
    var delegate: StudentManageDelegate?
    
//    var degreePickerView: UIPickerView!
    
    @IBOutlet weak var degreePickerView: UIPickerView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var degreeTF: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
        setUpPickerView()
    }
    
    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem)
    {
        
        if let firstName = firstNameTF.text, let lastName = lastNameTF.text, let degree = degreeTF.text, !firstName.isEmpty, !lastName.isEmpty, !degree.isEmpty
        {
            if self.fName == nil, self.lName == nil, self.degree == nil
            {
                delegate?.addStudent(fName: firstName, lName: lastName, degree: degree)
            }
            else
            {
                delegate?.editStudent(fName: firstName, lName: lastName, major: degree)
            }
        }
        else
        {
            AlertManager.alert(forWhichPage: self, alertType: .emptyTextField)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func setupUI()
    {
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        
        firstNameTF.text = fName
        lastNameTF.text = lName
        degreeTF.text = degree
        degreeTF.inputView = degreePickerView
    }
}
    // MARK: - Text Field Delegation
extension StudentInfoController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == degreeTF
        {
            degreePickerView.isHidden = false
        }
        
        return true
    }
}

    // MARK: - Picker View Delegation
extension StudentInfoController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func setUpPickerView()
    {
        degreePickerView.delegate = self
        degreePickerView.dataSource = self
        degreeTF.delegate = self
        degreePickerView.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return Degree.degree.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return Degree.degree[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        degreeTF.text = Degree.degree[row]
        degreePickerView.isHidden = true
        degreeTF.resignFirstResponder()
    }
}
