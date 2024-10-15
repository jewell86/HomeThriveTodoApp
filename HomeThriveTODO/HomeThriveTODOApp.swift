//
//  HomeThriveTODOApp.swift
//  HomeThriveTODO
//
//  Created by dxek on 10/15/24.
//

import SwiftUI

@main
struct HomeThriveTODOApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
