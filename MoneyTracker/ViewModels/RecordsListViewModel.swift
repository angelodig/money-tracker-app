//
//  RecordsListViewModel.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 01/12/20.
//

import Foundation
import SwiftUI
import Combine

class RecordsListViewModel {
    
    func convertRecordInRecordVM(_ record: FetchedResults<Record>.Element) -> RecordViewModel {
        let recordVM = RecordViewModel.init(record: record)
        return recordVM
    }
    
}
