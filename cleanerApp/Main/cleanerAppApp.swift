//
//  cleanerAppApp.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI
import RealmSwift

@main
struct CleanerApp: SwiftUI.App {
    @StateObject private var realmManager = RealmManager.shared
    @StateObject private var audioManager = AudioManager(realm: RealmManager.shared.realm)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(realmManager) 
                .environmentObject(audioManager)
        }
    }
}
