//
//  BalanceQuickRecapView.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 18/11/20.
//

import SwiftUI

struct BalanceView: View {
    private var balanceVM = BalanceViewModel()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Record.id, ascending: true)], animation: .default)
    private var records: FetchedResults<Record>
    
    var body: some View {
        VStack(alignment: .leading) {
            
            //Income Row
            TotalView(type: TypeRecord.income.rawValue, balanceVM: balanceVM, records: records, colorAmount: .green)
            
            //Expenses Row
            TotalView(type: TypeRecord.expenses.rawValue, balanceVM: balanceVM, records: records, colorAmount: .red)
            
            Divider()
                .padding(.vertical, -1.0)
            
            //Net Row
            HStack {
                Spacer()
                Text(balanceVM.net(allRecords: records))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(balanceVM.colorNetText(allRecords: records))
                    .padding([.top, .bottom], -5.0)
            }
        }
        .padding()
        .background(RectangleBackground())
    }
}


struct BalanceQuickRecapView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView()
    }
}

//MARK: Subviews
struct TotalView: View {
    var type: String
    var balanceVM: BalanceViewModel
    var records: FetchedResults<Record>
    var colorAmount: Color
    
    var body: some View {
        HStack {
            Text(type)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Text(balanceVM.totalOf(type, allRecords: records))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(colorAmount)
        }
    }
}


struct RectangleBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.yellow)
    }
}

