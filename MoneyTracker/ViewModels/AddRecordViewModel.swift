//
//  AddRecordViewModel.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 01/12/20.
//

import Foundation
import CoreData

class AddRecordViewModel {
    
    func saveOrUpdateRecord(_ viewContext: NSManagedObjectContext, _ record: RecordViewModel) throws {
        let isExisting: Bool = try DataManager.shared.checkExistingRecord(by: record.id, viewContext)
        if !isExisting {
            try saveRecord(viewContext, record)
        } else {
            try updateRecord(viewContext, record)
        }
    }
    
    func saveRecord(_ viewContext: NSManagedObjectContext, _ record: RecordViewModel) throws {
        try DataManager.shared.saveRecord(viewContext, id: record.id, title: record.title, date: record.date, type: record.type, category: record.category, tag: record.tag, note: record.note, amount: record.amount)
    }
    
    func updateRecord(_ viewContext: NSManagedObjectContext, _ record: RecordViewModel) throws {
        try DataManager.shared.updateRecord(id: record.id, title: record.title, date: record.date, type: record.type, category: record.category, tag: record.tag, note: record.note, amount: record.amount, viewContext)
    }
    
}
