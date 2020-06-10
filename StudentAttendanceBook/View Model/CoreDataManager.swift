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
    
    var students = [Students]()
    var filteredStudents = [Students]()
    
    var updateHandler: () -> () = {}
    
    
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - 
    
    func loadStudentData()
    {
        let context = persistentContainer.viewContext
        
        do
        {
            students = try context.fetch(Students.fetchRequest())
            updateHandler()
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
    
    func fetchDatabyDegree(degree: String, handler: (Bool) -> ())
    {
        let flag = true
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Students")
        request.predicate = NSPredicate(format: "degree contains %@", degree)
        request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true)]
        request.returnsObjectsAsFaults = false
        
        do
        {
            filteredStudents = try context.fetch(request) as! [Students]
            handler(flag)
        }
        catch
        {
            print("Failed")
        }
        
        updateHandler()
    }
    
}
