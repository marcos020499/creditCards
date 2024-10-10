//
//  CardsViewModel.swift
//  CreditCards
//
//  Created by Marcos Manzo.
//

import SwiftUI

@main
struct CreditCardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
