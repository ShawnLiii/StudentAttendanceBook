//
//  StudentViewModel.swift
//  StudentAttendanceBook
//
//  Created by Shawn Li on 6/11/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class StudentViewModel
{
    var students = [Students]()
    var updateHandler: () -> () = {}

    func loadStudentData()
    {
        CoreDataManager.shared.loadStudentData
            { (students) in
            self.students = students
            self.updateHandler()
        }
    }
    
    func fetchDatabyDegree(degree: String)
    {
        
        CoreDataManager.shared.filterData(firstName: nil, degree: degree)
        { (students) in
            self.students = students
            self.updateHandler()
        }
    }
    
    func fetchDatabyFirstName(firstName: String)
    {
        CoreDataManager.shared.filterData(firstName: firstName, degree: nil)
        { (students) in
            self.students = students
            self.updateHandler()
        }
    }
    
    func saveStudentData()
    {
        CoreDataManager.shared.saveContext()
    }
    
    func deleteStudentData(student: Students)
    {
        CoreDataManager.shared.deleteData(student: student)
    }
}
