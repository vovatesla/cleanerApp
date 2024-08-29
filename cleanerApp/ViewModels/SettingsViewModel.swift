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
    @AppStorage("selectedTab") var selectedTab: String = "Audio"
    
    private var realmManager: RealmManager

    // MARK: - Initializer
    
    init(realmManager: RealmManager) {
        self.realmManager = realmManager
    }

    // MARK: - Methods
    
    func clearHistory() {
        realmManager.clearHistory()
        print("History cleared")
    }
}
