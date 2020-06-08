//
//  StudentManageDelegate.swift
//  StudentAttendanceBook
//
//  Created by Shawn Li on 6/6/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import Foundation

protocol StudentManageDelegate
{
    func addStudent(fName: String, lName: String, degree: String)
    func editStudent(fName: String, lName: String, major: String)
}
