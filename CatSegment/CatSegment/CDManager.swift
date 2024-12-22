//
//  CDManager.swift
//  CatSegment
//
//  Created by Manthan Mittal on 22/12/2024.
//

import CoreData
import UIKit

class CDManager {
    
    //read func for CD
    
    func readFromCd() -> [CatModel] {
        
        var coreArr: [CatModel] = []
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = delegate!.persistentContainer.viewContext
        
        let fetchRes = NSFetchRequest<NSFetchRequestResult>(entityName: "Cats")
        
        do {
            
            let dataArr = try managedContext.fetch(fetchRes)
            
            for data in dataArr as! [NSManagedObject] {
                
                let cID = data.value(forKey: "id") as! String
                
                let cURL = data.value(forKey: "url") as! String
                
                let cWidth = data.value(forKey: "width") as! Int
                
                let cHeigth = data.value(forKey: "height") as! Int
                
                coreArr.append(CatModel(id: cID, url: cURL, width: cWidth, height: cHeigth))
                
                print("type: \(cURL)")
                
            }
            
        } catch let err as NSError {
            print(err)
        }
        return coreArr
    }
    
    //add func for CD
    
    func AddToCd(catToAdd: CatModel) {
        
        guard let delegate = UIApplication.shared.delegate as?AppDelegate else { return }
        
        let managedContext = delegate.persistentContainer.viewContext
        
        guard let catEnt = NSEntityDescription.entity(forEntityName: "Cats", in: managedContext) else { return }
        
        let cat = NSManagedObject(entity: catEnt, insertInto: managedContext)
        
        cat.setValue(catToAdd.id, forKey: "id")
        
        cat.setValue(catToAdd.url, forKey: "url")
        
        cat.setValue(catToAdd.width, forKey: "width")
        
        cat.setValue(catToAdd.height, forKey: "height")
        
        do {
            
            try managedContext.save()
            print("Cat is saved successfully!")
            
        }catch let err as NSError {
            print(err)
        }
    }
    
    
    //delete func for CD
    
    func deleteFromCD(cats: CatModel) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cats")
        
        // Correct predicate format for the id
        fetchRequest.predicate = NSPredicate(format: "id = %@", cats.id)

        do {
            let fetchRes = try managedContext.fetch(fetchRequest)

            // Check if fetchRes is not empty before trying to access its first element
            if fetchRes.isEmpty {
                print("No matching cat found to delete.")
                return
            }

            // Proceed with deletion if object is found
            let objToDelete = fetchRes[0] as! NSManagedObject
            managedContext.delete(objToDelete)
            
            try managedContext.save()
            print("Cat deleted successfully")
        } catch let err as NSError {
            print("Something went wrong while deleting \(err)")
        }
    }

    
    //update func for CD
    
        func updateInCD(updateCat: CatModel, completion: @escaping (Bool) -> Void) {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                completion(false)
                return
            }
            
            let managedContext = delegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cats")
            
            // Add a predicate to filter by 'id'
            fetchRequest.predicate = NSPredicate(format: "id == %@", updateCat.id)
            
            do {
                let rawData = try managedContext.fetch(fetchRequest)
                
                // Make sure there is data to update
                if let objUpdate = rawData.first as? NSManagedObject {
                    objUpdate.setValue(updateCat.id, forKey: "id")
                    objUpdate.setValue(updateCat.url, forKey: "url")
                    objUpdate.setValue(updateCat.width, forKey: "width")
                    objUpdate.setValue(updateCat.height, forKey: "height")
                    
                    try managedContext.save()
                    print("Data updated successfully")
                    completion(true)
                } else {
                    print("No matching record found")
                    completion(false)
                }
            } catch let error as NSError {
                print("Error updating data: \(error.localizedDescription)")
                completion(false)
            }
        }


    
}
