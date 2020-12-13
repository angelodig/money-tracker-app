//
//  RecordsFeedView.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 24/11/20.
//

import SwiftUI

struct RecordsListView: View {
    private var recordListViewModel = RecordsListViewModel()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Record.date, ascending: false)], animation: .default)
    private var records: FetchedResults<Record>
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Your Transactions: ")
                    .fontWeight(.bold)
                Spacer()
            }
            
            ScrollView {
                LazyVStack {
                    ForEach(records, id: \.self) { r in
                        RecordRow(recordVM: self.recordListViewModel.convertRecordInRecordVM(r), fetchedRecord: r, recordData: RecordData())
                    }
                }
            }
        }
    }
}

struct TransactionsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
