//
//  StudentABController.swift
//  StudentAttendanceBook
//
//  Created by Shawn Li on 6/6/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class StudentABController: UITableViewController
{
    
    var students = [Students]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var row = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadStudentData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let studentInfoVC = segue.destination as! StudentInfoController
        studentInfoVC.delegate = self
        
        if segue.identifier == "edit"
        {
            updateStudentData(viewController: studentInfoVC, sender: sender)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "student", for: indexPath) as! StudentsInfoCell
        
        cell.configure(students: students, indexPath: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        students[indexPath.row].checked = !students[indexPath.row].checked
        // Save Data
        saveStudentData()
        // Change View
        let cell = tableView.cellForRow(at: indexPath) as! StudentsInfoCell
        cell.checkMarkLbl.text = students[indexPath.row].checked ? "✓" : "x"
        // deselect
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            // Delete from Core Data
            context.delete(students[indexPath.row])
            // Delete from Container
            students.remove(at: indexPath.row)
            // Save Change
            saveStudentData()
            //Update View
            tableView.reloadData()
        }
    }
}

    //MARK: - Core Data and Delegation Function
extension StudentABController: StudentManageDelegate
{

    func loadStudentData()
    {
        do
        {
            students = try context.fetch(Students.fetchRequest())
            tableView.reloadData()
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func saveStudentData()
    {
        do
        {
            try context.save()
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func updateStudentData(viewController: StudentInfoController, sender: Any?)
    {
        let cell = sender as! StudentsInfoCell
        
        row = tableView.indexPath(for: cell)!.row
        viewController.fName = students[row].firstName
        viewController.lName = students[row].lastName
        viewController.major = students[row].major
    }
    
    func addStudent(fName: String, lName: String, major: String)
    {
        let student = Students(context: context)
        student.firstName = fName
        student.lastName = lName
        student.major = major
        student.checked = false
        //Store Data to container
        students.append(student)
        //Store Data to Core Data
        saveStudentData()
        //Update View
        tableView.reloadData()
    }
    
    func editStudent(fName: String, lName: String, major: String)
    {
        //Edit Data
        students[row].firstName = fName
        students[row].lastName = lName
        students[row].major = major
        //Save Data to Core Data
        saveStudentData()
        //Update View
        tableView.reloadData()
    }
}
