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
    
    let studentViewModel = StudentViewModel()
    var row = 0
    let searchController = UISearchController(searchResultsController: nil)
    
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
        studentViewModel.loadStudentData()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return studentViewModel.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "student", for: indexPath) as! StudentsInfoCell

        cell.configure(student: studentViewModel.students[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        studentViewModel.students[indexPath.row].checked = !studentViewModel.students[indexPath.row].checked
        // Save Data
        studentViewModel.saveStudentData()
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
            studentViewModel.deleteStudentData(student: studentViewModel.students[indexPath.row])
            // Delete from Container
            studentViewModel.students.remove(at: indexPath.row)
            // Save Change
            studentViewModel.saveStudentData()
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
        
        let student = studentViewModel.students[row]
        viewController.fName = student.firstName
        viewController.lName = student.lastName
        viewController.degree = student.degree
        
    }
    
    func addStudent(fName: String, lName: String, degree: String)
    {
        let student = Students(context: CoreDataManager.shared.persistentContainer.viewContext)
        student.firstName = fName
        student.lastName = lName
        student.degree = degree
        student.checked = false
        //Store Data to container
        studentViewModel.students.append(student)
        //Store Data to Core Data
        studentViewModel.saveStudentData()
        //Update View
        tableView.reloadData()
    }
    
    func editStudent(fName: String, lName: String, major: String)
    {
        //Edit Data
        let student = studentViewModel.students[row]
        student.firstName = fName
        student.lastName = lName
        student.degree = major
        //Save Data to Core Data
        studentViewModel.saveStudentData()
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
        studentViewModel.fetchDatabyFirstName(firstName: searchText)
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
    }
    
}
