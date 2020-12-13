//
//  AddRecordView.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 18/11/20.
//

import SwiftUI

class ShowViewState: ObservableObject {
    @Published fileprivate var showEditRecordView: Bool = false
    @Published fileprivate var showErrorAlert: Bool = false
}

struct RecordRow: View {
    var recordVM: RecordViewModel
    
    var fetchedRecord: FetchedResults<Record>.Element
    var recordData: RecordData
    
    @State private var showDetail: Bool = false
    @ObservedObject var showViewState = ShowViewState()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3.0) {
            
            VStack(alignment: .leading, spacing: 3.0) {
                HStack {
                    DateRecord(dateString: recordVM.dateString)
                    Spacer()
                    Image(systemName: showDetail ? "chevron.down" : "chevron.right")
                }
                TitleRecord(title: recordVM.title)
            }
            
            HStack {
                TypeView(imageName: recordVM.typeImageName, colorImage: recordVM.colorImageType)
                CategoryLabel(labelName: recordVM.category, labelColor: recordVM.colorCategoryLabel)
                NoteAttachedView() //TODO:
                Spacer()
                Amount(amountString: recordVM.amountString, color: recordVM.colorImageType)
            }
            
            TagView()//TODO:
            
            if showDetail {
                ShowDetailButton(showViewState: showViewState, recordFetched: fetchedRecord, recordData: recordData, recordVM: recordVM)
            }
        }
        .contentShape(Rectangle()) ///Used to tap on entire row
        .onTapGesture {
            self.showDetail.toggle()
        }
        .sheet(isPresented: $showViewState.showEditRecordView, content: {
            AddRecordView(recordData: recordData, mainButtonViewIsOpen: .constant(false), addIsPresented: $showViewState.showEditRecordView)
        })
        .alert(isPresented: $showViewState.showErrorAlert, content: {
            Alert(title: Text("Error"), message: Text("Impossible to delete"), dismissButton: .cancel())
        })
        .padding()
        .background(Rectangle().fill(Color.gray).cornerRadius(10).opacity(0.2))
        
    }
}

struct TransactionCellView_Previews: PreviewProvider {
    static var previews: some View {
        RecordRow(recordVM: RecordViewModel.init(id: UUID(), title: "Shopping", date: Date(), type: TypeRecord.income.rawValue, category: ExpensesCategoryRecord.necessity.rawValue, tag: "", note: "", amount: 12345678), fetchedRecord: FetchedResults<Record>.Element(), recordData: RecordData())
    }
}

//MARK: Subviews

struct TitleRecord: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.heavy)
            .lineLimit(1)
    }
}

struct DateRecord: View {
    var dateString: String
    var body: some View {
        Text(dateString)
            .font(.footnote)
            .foregroundColor(.gray)
    }
}

struct TypeView: View {
    var imageName: String
    var colorImage: Color
    var body: some View {
        Image(systemName: imageName)
            .foregroundColor(colorImage)
            .font(.title3)
    }
}

struct CategoryLabel: View {
    var labelName: String
    var labelColor: Color
    var body: some View {
        Label(labelName, systemImage: "tag.circle.fill")
            .foregroundColor(.white)
            .font(.headline)
            .padding(3)
            .background(RectangleBackgroundCategoryText(color: labelColor))
            .lineLimit(/*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
}


struct RectangleBackgroundCategoryText: View {
    var color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 10.0)
            .fill(color)
    }
}

struct NoteAttachedView: View {
    var body: some View {
        Image(systemName: "paperclip")
            .font(.title2)
            .foregroundColor(.gray)
    }
}

struct TagView: View {
    var body: some View {
        HStack {
            ForEach(0..<3) { item in
                Text("tag\(item + 1)")
                    .fontWeight(.semibold)
            }
        }
        .font(.footnote)
        .foregroundColor(.gray)
    }
}

struct Amount: View {
    var amountString: String
    var color: Color
    var body: some View {
        Text(amountString)
            .foregroundColor(color)
            .fontWeight(.bold)
            .font(.title3)
            .multilineTextAlignment(.trailing)
            .lineLimit(1)
    }
}

struct ShowDetailButton: View {
    var showViewState: ShowViewState
    var recordRowVM = RecordRowViewModel()
    @Environment(\.managedObjectContext) private var viewContest
    var recordFetched: FetchedResults<Record>.Element
    var recordData: RecordData
    var recordVM: RecordViewModel
    
    var body: some View {
        VStack(spacing: 5.0) {
            Text(recordVM.note)
            HStack(spacing: 40.0) {
                Spacer()
                //Edit Button
                Button(action: {
                    editRecord()
                }) {
                    Image(systemName: "pencil")
                        .font(.title2)
                }
                //Delete Button
                Button(action: {
                    deleteRecord() //TODO: alert confirm (undo)
                }) {
                    Image(systemName: "trash.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                Spacer()
            }
        }
    }
    
    //Edit
    private func editRecord() {
        recordData.id = recordVM.id
        recordData.title = recordVM.title
        recordData.date = recordVM.date
        recordData.type = recordVM.type
        recordData.category = recordVM.category
        recordData.tag = recordVM.tag
        recordData.note = recordVM.note
        recordData.amountString = recordVM.amountStringNoCurrency
        
        showViewState.showEditRecordView = true
    }
    
    //Delete
    private func deleteRecord() {
        do {
            try self.recordRowVM.deleteRecord(viewContest, recordFetched)
            showViewState.showErrorAlert = false
        } catch {
            let nsError = error as NSError
            print("Error delete record: \(nsError)")
            //fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            showViewState.showErrorAlert = true
        }
    }
}
