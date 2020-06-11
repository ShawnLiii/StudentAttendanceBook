//
//  CoreDataManager.swift
//  StudentAttendanceBook
//
//  Created by Shawn Li on 6/10/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager
{
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer =
    {
        let container = NSPersistentContainer(name: "StudentAttendanceBook")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?
            {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext ()
    {
        let context = persistentContainer.viewContext
        if context.hasChanges
        {
            do
            {
                try context.save()
            }
            catch
            {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Data Manager function
    
    func loadStudentData(handler: ([Students]) -> ())
    {
        var students = [Students]()
        let context = persistentContainer.viewContext
        
        do
        {
            students = try context.fetch(Students.fetchRequest())
            handler(students)
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func saveStudentData()
    {
        let context = persistentContainer.viewContext
        
        do
        {
            try context.save()
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func fetchDatabyDegree(degree: String, handler: ([Students]) -> ())
    {
        var filteredStudents = [Students]()
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Students")
        
        request.predicate = NSPredicate(format: "degree contains %@", degree)
        request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true)]
        request.returnsObjectsAsFaults = false
        
        do
        {
            filteredStudents = try context.fetch(request) as! [Students]
            handler(filteredStudents)
        }
        catch
        {
            print("Failed")
        }
    }
    
    func deleteData(student: Students)
    {
        let context = persistentContainer.viewContext
        context.delete(student)
    }
    
}
