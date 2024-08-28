//
//  ContentView.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI
import RealmSwift

// MARK: - ContentView

struct ContentView: View {
    @EnvironmentObject private var realmManager: RealmManager
    @StateObject private var settingsViewModel = SettingsViewModel(realmManager: RealmManager.shared)
    @State private var tabSelection: Int = 2 // Default to Cleaner

    private var tabMapping: [String: Int] = [
        "Audio": 0,
        "History": 1,
        "Cleaner": 2,
        "Settings": 3
    ]

    var body: some View {
        TabView(selection: $tabSelection) {
            AudioView()
                .tabItem {
                    Label("Audio", systemImage: "mic.fill")
                }
                .tag(0)
                .onAppear {
                    if tabSelection == 0 {
                        triggerHapticFeedback()
                    }
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
                .tag(1)
                .onAppear {
                    if tabSelection == 1 {
                        triggerHapticFeedback()
                    }
                }

            CleanerView()
                .tabItem {
                    Label("Cleaner", systemImage: "bolt.heart.fill")
                }
                .tag(2)
                .onAppear {
                    if tabSelection == 2 {
                        triggerHapticFeedback()
                    }
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
                .onAppear {
                    if tabSelection == 3 {
                        triggerHapticFeedback()
                    }
                }
        }
        .accentColor(.orange)
        .background(Color(red: 37/255, green: 31/255, blue: 69/255))
        .onAppear {
            // Set tabSelection based on saved preferences if needed
            if let savedTabIndex = tabMapping[settingsViewModel.selectedTab] {
                tabSelection = savedTabIndex
            }
        }
    }

    // MARK: - Haptic Feedback

    private func triggerHapticFeedback() {
        guard settingsViewModel.isHapticsEnabled else { return }
        let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactGenerator.impactOccurred()
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RealmManager.shared)
    }
}
