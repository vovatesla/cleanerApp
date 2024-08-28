//
//  SettingsViewModel.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import RealmSwift
import Combine
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @AppStorage("isHapticsEnabled") var isHapticsEnabled: Bool = true
    @AppStorage("selectedTab") var selectedTab: String = "Audio" // Default value or retrieve from user defaults

    private var realmManager: RealmManager

    // MARK: - Initializer
    
    init(realmManager: RealmManager) {
        self.realmManager = realmManager
    }

    // MARK: - Methods
    
    func clearHistory() {
        do {
            realmManager.clearHistory() // Use clearHistory from realmManager directly
            print("History cleared") // Ensure this line is executed
        } catch {
            print("Error clearing history in ViewModel: \(error.localizedDescription)")
        }
    }
}
