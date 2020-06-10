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
    var row = 0
    let searchController = UISearchController(searchResultsController: nil)
    var isSegementUsing = false
    
    @IBOutlet weak var degreeSegment: UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        CoreDataManager.shared.loadStudentData()
        remindAlter()
        setupSearchBar()
        CoreDataManager.shared.updateHandler = self.tableView.reloadData
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
            return CoreDataManager.shared.filteredStudents.count
        }
        
        return CoreDataManager.shared.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "student", for: indexPath) as! StudentsInfoCell
        
        if isFiltering
        {
            cell.configure(students: CoreDataManager.shared.filteredStudents, indexPath: indexPath)
        }
        else
        {
            cell.configure(students: CoreDataManager.shared.students, indexPath: indexPath)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        CoreDataManager.shared.students[indexPath.row].checked = !CoreDataManager.shared.students[indexPath.row].checked
        // Save Data
        
        CoreDataManager.shared.saveStudentData()
        // Change View
        let cell = tableView.cellForRow(at: indexPath) as! StudentsInfoCell
        cell.checkMarkLbl.text = CoreDataManager.shared.students[indexPath.row].checked ? "✓" : "x"
        // deselect
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            // Delete from Core Data
            context.delete(CoreDataManager.shared.students[indexPath.row])
            // Delete from Container
            CoreDataManager.shared.students.remove(at: indexPath.row)
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
            viewController.fName =  CoreDataManager.shared.filteredStudents[row].firstName
            viewController.lName = CoreDataManager.shared.filteredStudents[row].lastName
            viewController.degree = CoreDataManager.shared.filteredStudents[row].degree
        }
        else
        {
            viewController.fName = CoreDataManager.shared.students[row].firstName
            viewController.lName = CoreDataManager.shared.students[row].lastName
            viewController.degree = CoreDataManager.shared.students[row].degree
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
        CoreDataManager.shared.students.append(student)
        //Store Data to Core Data
        CoreDataManager.shared.saveStudentData()
        //Update View
        tableView.reloadData()
    }
    
    func editStudent(fName: String, lName: String, major: String)
    {
        //Edit Data
        CoreDataManager.shared.students[row].firstName = fName
        CoreDataManager.shared.students[row].lastName = lName
        CoreDataManager.shared.students[row].degree = major
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
        CoreDataManager.shared.filteredStudents = CoreDataManager.shared.students.filter
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
        
        CoreDataManager.shared.fetchDatabyDegree(degree: degree)
        { (flag) in
            isSegementUsing = flag
        }
    }
    
}
