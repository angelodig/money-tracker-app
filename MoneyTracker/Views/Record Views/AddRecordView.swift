//
//  AddRecordView.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 18/11/20.
//

import SwiftUI

//MARK: Record Data
class RecordData: ObservableObject {
    @Published var id: UUID = UUID()
    @Published var title: String = ""
    @Published var date: Date = Date()
    @Published var type: TypeRecord.RawValue = TypeRecord.expenses.rawValue
    @Published var category: String = "Necessity"
    @Published var tag: String = ""
    @Published var note: String = ""
    @Published var amountString: String = ""
}

//MARK: View
struct AddRecordView: View {
    @Environment(\.managedObjectContext) private var viewContext 
    
    private let addRecordviewModel = AddRecordViewModel()
    @ObservedObject var recordData: RecordData
    
    @Binding var mainButtonViewIsOpen: Bool
    @Binding var addIsPresented: Bool
    @State private var alertErrorIsPresented: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15.0) {
            //Title
                TitleTextField(title: $recordData.title)
            //Date & Type
                HStack {
                    DatePicker(selection: $recordData.date, displayedComponents: .date, label: { Text("Date:")
                    })
                    .labelsHidden()
                    TypeSegmentedController(type: $recordData.type)
                }
                
            //Category //TODO:
                NavigationLink(destination: CategoryListView(category: $recordData.category)) {
                    CategoryRow(category: recordData.category)
                }
            //TODO: TagRow()
                
            //Note
                AddNote(text: $recordData.note)
            //Amount
                AmountTextField(amountString: $recordData.amountString, type: $recordData.type)
                Spacer()
            }
            .padding([.top, .leading, .trailing])
            .navigationBarTitle(Text("Transaction"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: { dismiss() }) { Text("Dismiss") },
                trailing: Button(action: { saveOrUpdateRecord() }) { Text("Save") }
            )
        }
        .alert(isPresented: $alertErrorIsPresented, content: {
            Alert(title: Text("Error"), message: Text("Check information"), dismissButton: .cancel())
        })
    }
    
    
    //MARK: Methods
    private func saveOrUpdateRecord() {
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        
        guard let amountDouble = formatter.number(from: recordData.amountString)?.doubleValue else { return alertErrorIsPresented = true}
        
        let r = RecordViewModel(id: recordData.id, title: recordData.title, date: recordData.date, type: recordData.type, category: recordData.category, tag: recordData.tag, note: recordData.note, amount: amountDouble)
        //print(recordData.title, recordData.type, recordData.category, recordData.amountString, amountDouble, recordData.date, recordData.tag, recordData.note)
        do {
            try addRecordviewModel.saveOrUpdateRecord(viewContext, r)
            alertErrorIsPresented = false
            dismiss()
        } catch {
            let nsError = error as NSError
            print("Error save record: \(nsError)")
            //fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            alertErrorIsPresented = true
        }
    }
    
    private func dismiss() {
        self.addIsPresented.toggle()
        self.mainButtonViewIsOpen.toggle()
    }
    
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView(recordData: RecordData(), mainButtonViewIsOpen: .constant(false), addIsPresented: .constant(true))
    }
}

//MARK: Subviews

struct TitleTextField: View {
    @Binding var title: String
    var body: some View {
        TextField("Title Transaction", text: $title)
            .font(Font.system(size: 20, weight: .semibold))
    }
}

struct TypeSegmentedController: View {
    @Binding var type: String
    
    var body: some View {
        Picker(selection: $type, label: Text("Picker")) {
            Image(systemName: "minus.circle").tag(TypeRecord.expenses.rawValue)
            Image(systemName: "plus.circle").tag(TypeRecord.income.rawValue)
        }
        .labelsHidden()
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct CategoryRow: View {
    var category: String
    var body: some View {
        HStack {
            Text("Category:")
            Spacer()
            Text(category)
                .foregroundColor(.black)
        }
    }
}

struct CategoryListView: View {
    @Binding var category: String
    
    var body: some View {
        Form {
            Section(header: Text("Categories:")) {
                List(content: {
                    ForEach(ExpensesCategoryRecord.allCategories, id: \.self) { cat in
                        Button(action: {
                            category = cat.rawValue
                            //TODO: go back
                        }, label: {
                            HStack {
                                Text(cat.rawValue)
                                if category == cat.rawValue {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        })
                    }
                })
            }
        }
    }
}

//struct TagRow: View {
//    var body: some View {
//        HStack {
//            Text("Tag:")
//            Spacer()
//            Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
//                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Button")/*@END_MENU_TOKEN@*/
//            }
//        }
//    }
//}

struct AddNote: View {
    @Binding var text: String
    var body: some View {
        VStack {
            Divider()
                .padding(.horizontal)
            TextField("Add a note...", text: $text)
                .font(.body)
            Divider()
                .padding(.horizontal)
        }
    }
}

struct AmountTextField: View {
    @Binding var amountString: String
    @Binding var type: String
    
    var body: some View {
        TextField("0", text: $amountString)
            .multilineTextAlignment(.center)
            .font(Font.system(size: 40, weight: .semibold))
            .foregroundColor(colorTextAmountBy(type))
            .keyboardType(.decimalPad)
    }
    
    private func colorTextAmountBy(_ type: String) -> Color {
        var color: Color = .black
        if type == TypeRecord.expenses.rawValue {
            color = .red
        } else if type == TypeRecord.income.rawValue {
            color = .green
        }
        return color
    }
    
}
