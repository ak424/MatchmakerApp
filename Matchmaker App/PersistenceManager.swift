//
//  PersistenceManager.swift
//  Matchmaker App
//
//  Created by Arav Khandelwal on 25/07/24.
//

import Foundation
import CoreData

class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    private init() {}
    
    /// Peristence container object to be created once.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MatchmakerApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// To save context for core data
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// Save the card detail if non existent before
    /// - Parameter cardDetail: card detail object to be stored
    func saveCardDetail(cardDetail: CardDetailsModel) {
        if !doesCardDetailExist(idValue: cardDetail.idValue) {
          let cardDetailsEntity = CardDetails.fromCardDetailsModel(cardDetail, context: context)
          context.insert(cardDetailsEntity)
          saveContext()
        } else {
            // add non fatal here
          print("CardDetail with idValue \(cardDetail.idValue) already exists.")
        }
    }
    
    /// To retrieve the the data from Core Data
    /// - Returns: Returns the list of all the model classes stored .
    func fetchCardDetails() -> [CardDetailsModel] {
        let fetchRequest: NSFetchRequest<CardDetails> = CardDetails.fetchRequest()
        
        do {
            let cardDetailsList = try context.fetch(fetchRequest)
            return cardDetailsList.map { $0.toCardDetailsModel() }
        } catch {
            // add non fatal here
            print("Failed to fetch card details: \(error)")
            return []
        }
    }
    
    func updateCardDetail(cardDetail: CardDetailsModel) {
        let fetchRequest: NSFetchRequest<CardDetails> = CardDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idValue == %@", cardDetail.idValue)
        fetchRequest.fetchLimit = 1
        
        do {
            let cardDetailsList = try context.fetch(fetchRequest)
            if let cardDetailsEntity = cardDetailsList.first {
                cardDetailsEntity.imageURL = cardDetail.imageURL
                cardDetailsEntity.fullName = cardDetail.fullName
                cardDetailsEntity.fullAddress = cardDetail.fullAddress
                cardDetailsEntity.age = Int32(cardDetail.age)
                cardDetailsEntity.status = cardDetail.status.rawValue
                saveContext()
            } else {
                // add non fatal here
                print("No CardDetail found with idValue \(cardDetail.idValue) to update.")
            }
        } catch {
            // add non fatal here
            print("Failed to update card detail with idValue \(cardDetail.idValue): \(error)")
        }
    }
    
    /// To clear all the data stored corresponding to the required entity
    func clearAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "CardDetails")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            // add non fatal here
            print("Failed to clear data: \(error)")
        }
    }
    
    /// To check if any card exists before with that idValues
    /// - Parameter idValue: this acts as a unique identifier
    /// - Returns: Returns whether the card detail exist or not
    private func doesCardDetailExist(idValue: String) -> Bool {
        let fetchRequest: NSFetchRequest<CardDetails> = CardDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idValue == %@", idValue)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            // add non fatal here
            print("Failed to fetch card details: \(error)")
            return false
        }
    }
}
