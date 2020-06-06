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
    var major: String?
    var delegate: StudentManageDelegate?
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var majorTF: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem)
    {
        
        if let firstName = firstNameTF.text, let lastName = lastNameTF.text, let major = majorTF.text, !firstName.isEmpty, !lastName.isEmpty, !major.isEmpty
        {
            if self.fName == nil, self.lName == nil, self.major == nil
            {
                delegate?.addStudent(fName: firstName, lName: lastName, major: major)
            }
            else
            {
                delegate?.editStudent(fName: firstName, lName: lastName, major: major)
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
        majorTF.delegate = self
        
        firstNameTF.text = fName
        lastNameTF.text = lName
        majorTF.text = major
    }
}
    // MARK: - Text Field Delegation
extension StudentInfoController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        firstNameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
        majorTF.resignFirstResponder()
        
        return true
    }
}
