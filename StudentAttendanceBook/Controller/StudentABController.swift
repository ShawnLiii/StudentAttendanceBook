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
    var filteredStudents = [Students]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var row = 0
    //Use the same view you’re searching to display the results
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadStudentData()
        remindAlter()
        setupSearchBar()
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
    
    func remindAlter()
    {
        AlertManager.alert(forWhichPage: self, alertType: .operationGuide)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering
        {
          return filteredStudents.count
        }
        
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "student", for: indexPath) as! StudentsInfoCell
        
        if isFiltering
        {
            cell.configure(students: filteredStudents, indexPath: indexPath)
        }
        else
        {
            cell.configure(students: students, indexPath: indexPath)
        }
        
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
        
        if isFiltering
        {
            viewController.fName =  filteredStudents[row].firstName
            viewController.lName = filteredStudents[row].lastName
            viewController.degree = filteredStudents[row].degree
        }
        else
        {
            viewController.fName = students[row].firstName
            viewController.lName = students[row].lastName
            viewController.degree = students[row].degree
        }
        
    }
    
    func addStudent(fName: String, lName: String, degree: String)
    {
        let student = Students(context: context)
        student.firstName = fName
        student.lastName = lName
        student.degree = degree
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
        students[row].degree = major
        //Save Data to Core Data
        saveStudentData()
        //Update View
        tableView.reloadData()
    }
}

// MARK: - Search Bar Configuration

extension StudentABController: UISearchResultsUpdating
{
    var isSearchBarEmpty: Bool
    {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool
    {
      return searchController.isActive && !isSearchBarEmpty
    }

    func setupSearchBar()
    {
        // Inform self class of any text changes within the UISearchBar
        searchController.searchResultsUpdater = self
        // Set the current view to show the results, so you don’t want to obscure your view
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Students By First Name"
        navigationItem.searchController = searchController
        // 5 Ensure that the search bar doesn’t remain on the screen if the user navigates to another view controller while the UISearchController is active.
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        filteredStudents = students.filter
        { (student: Students) -> Bool in
            
            return student.firstName!.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }


}
