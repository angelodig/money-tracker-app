//
//  DataManager.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 29/11/20.
//

import Foundation
import UIKit
import CoreData
import SwiftUI

class DataManager {
    static let shared = DataManager()
    
    //Add Record
    func saveRecord(_ viewContext: NSManagedObjectContext, id: UUID, title: String, date: Date, type: String, category: String, tag: String, note: String, amount: Double) throws {
        //TODO: aggiungi al guard: record.tag != ""
        guard title != "", type != "", category != "", amount != 0 else { throw ErrorSaveRecord.missingInfoRecord }
        
        let newRecord = Record(context: viewContext)
        newRecord.id = id
        newRecord.title = title
        newRecord.date = date
        newRecord.type = type
        newRecord.category = category
        newRecord.tag = tag
        newRecord.note = note
        newRecord.amount = amount
        
        try viewContext.save()
    }
    
    //Remove Record
    func removeRecord(viewContext: NSManagedObjectContext, _ record: FetchedResults<Record>.Element) throws {
        viewContext.delete(record)
        try viewContext.save()
    }
    
    //Update Record
    func updateRecord(id: UUID, title: String, date: Date, type: String, category: String, tag: String, note: String, amount: Double, _ viewContext: NSManagedObjectContext) throws {
        //TODO: aggiungi al guard: updatedRecord.tag != ""
        guard title != "", type != "", category != "", amount != 0 else { throw ErrorSaveRecord.missingInfoRecord }
        
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "id=%@", id.uuidString)
        
        let recordToUpdate = try viewContext.fetch(fetchRequest).first
        
        recordToUpdate?.id = id
        recordToUpdate?.title = title
        recordToUpdate?.date = date
        recordToUpdate?.type = type
        recordToUpdate?.category = category
        recordToUpdate?.tag = tag
        recordToUpdate?.note = note
        recordToUpdate?.amount = amount
        
        try viewContext.save()
    }
    
    //Check if record exist
    func checkExistingRecord(by id: UUID, _ viewContext: NSManagedObjectContext) throws -> Bool {

        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "id=%@", id.uuidString)

        guard (try viewContext.fetch(fetchRequest).first) != nil else {
            return false
        }

        return true
    }
}
