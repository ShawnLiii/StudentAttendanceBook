//
//  StudentABController.swift
//  StudentAttendanceBook
//
//  Created by Shawn Li on 6/6/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit
import CoreData

class StudentABController: UITableViewController
{
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    let studentViewModel = StudentViewModel()
    var row = 0
    let searchController = UISearchController(searchResultsController: nil)
    var isSegementUsing = false
    
    @IBOutlet weak var degreeSegment: UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        remindAlter()
        setupSearchBar()
        studentViewModel.updateHandler = self.tableView.reloadData
        studentViewModel.loadStudentData()
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
    
    @IBAction func resetTapped(_ sender: UIBarButtonItem)
    {
        isSegementUsing = false
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering
        {
            return studentViewModel.filteredStudents.count
        }
        
        return studentViewModel.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "student", for: indexPath) as! StudentsInfoCell
        
        if isFiltering
        {
            cell.configure(students: studentViewModel.filteredStudents, indexPath: indexPath)
        }
        else
        {
            cell.configure(students: studentViewModel.students, indexPath: indexPath)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        studentViewModel.students[indexPath.row].checked = !studentViewModel.students[indexPath.row].checked
        // Save Data
        
        CoreDataManager.shared.saveStudentData()
        // Change View
        let cell = tableView.cellForRow(at: indexPath) as! StudentsInfoCell
        cell.checkMarkLbl.text = studentViewModel.students[indexPath.row].checked ? "✓" : "x"
        // deselect
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            // Delete from Core Data
            CoreDataManager.shared.deleteData(student: studentViewModel.students[indexPath.row])
            // Delete from Container
            studentViewModel.students.remove(at: indexPath.row)
            // Save Change
            CoreDataManager.shared.saveStudentData()
            //Update View
            tableView.reloadData()
        }
    }
}

//MARK: - Core Data and Delegation Function
extension StudentABController: StudentManageDelegate
{
    
    func updateStudentData(viewController: StudentInfoController, sender: Any?)
    {
        let cell = sender as! StudentsInfoCell
        row = tableView.indexPath(for: cell)!.row
        
        if isFiltering
        {
            viewController.fName =  studentViewModel.filteredStudents[row].firstName
            viewController.lName = studentViewModel.filteredStudents[row].lastName
            viewController.degree = studentViewModel.filteredStudents[row].degree
        }
        else
        {
            viewController.fName = studentViewModel.students[row].firstName
            viewController.lName = studentViewModel.students[row].lastName
            viewController.degree = studentViewModel.students[row].degree
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
        studentViewModel.students.append(student)
        //Store Data to Core Data
        CoreDataManager.shared.saveStudentData()
        //Update View
        tableView.reloadData()
    }
    
    func editStudent(fName: String, lName: String, major: String)
    {
        //Edit Data
        studentViewModel.students[row].firstName = fName
        studentViewModel.students[row].lastName = lName
        studentViewModel.students[row].degree = major
        //Save Data to Core Data
        CoreDataManager.shared.saveStudentData()
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
        return (searchController.isActive && !isSearchBarEmpty) || isSegementUsing
    }
    
    func setupSearchBar()
    {
        // Inform self class of any text changes within the UISearchBar
        searchController.searchResultsUpdater = self
        // Set the current view to show the results, so you don’t want to obscure your view
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Students By First Name"
        navigationItem.searchController = searchController
        // Ensure that the search bar doesn’t remain on the screen if the user navigates to another view controller while the UISearchController is active.
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String)
    {
        studentViewModel.filteredStudents = studentViewModel.students.filter
        { (student: Students) -> Bool in
            return student.firstName!.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}

// Segment Control
extension StudentABController
{
    
    @IBAction func degreeSegmentTapped(_ sender: UISegmentedControl)
    {
        let getIndex = degreeSegment.selectedSegmentIndex
        let degree = Degree.degree[getIndex]
        
        studentViewModel.fetchDatabyDegree(degree: degree)
        { (flag) in
            isSegementUsing = flag
        }
    }
    
}
