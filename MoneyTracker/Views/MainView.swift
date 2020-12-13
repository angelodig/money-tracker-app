//
//  ContentView.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 18/11/20.
//

import SwiftUI
import UIKit

struct MainView: View {
    var body: some View {
        ZStack {
            VStack {
                BalanceView()
                RecordsListView()
            }
            .navigationTitle(Text("Balance"))
            .padding(.horizontal)
            MainButtonView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
