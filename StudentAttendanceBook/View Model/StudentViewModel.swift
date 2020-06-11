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
    var filteredStudents = [Students]()
    var updateHandler: () -> () = {}

    func loadStudentData()
    {
        CoreDataManager.shared.loadStudentData
            { (students) in
            self.students = students
            self.updateHandler()
        }
    }
    
    func fetchDatabyDegree(degree: String, handler: (Bool) -> ())
    {
        let flag = true
        
        CoreDataManager.shared.fetchDatabyDegree(degree: degree)
        { (students) in
            self.filteredStudents = students
            handler(flag)
            self.updateHandler()
        }
        
    }
}
