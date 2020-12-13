//
//  MoneyTrackerApp.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 18/11/20.
//

import SwiftUI

@main
struct MoneyTrackerApp: App {
    
    let persistentContainer = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistentContainer.container.viewContext)
                .onAppear(perform: {
                    ///Print database location. Go to: Library -> Application Support
                    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                        print(urls[urls.count-1] as URL)
                })
        }
    }
}
