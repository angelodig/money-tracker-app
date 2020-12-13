//
//  RecordRowViewModel.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 09/12/20.
//

import Foundation
import SwiftUI
import CoreData

class RecordRowViewModel {
    func deleteRecord(_ viewContext: NSManagedObjectContext, _ record: FetchedResults<Record>.Element) throws {
        try DataManager.shared.removeRecord(viewContext: viewContext, record)
    }
}
