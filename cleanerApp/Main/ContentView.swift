//
//  ContentView.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @EnvironmentObject private var realmManager: RealmManager
    @EnvironmentObject private var bannerService: BannerService
    @StateObject private var settingsViewModel: SettingsViewModel
    
    @State private var tabSelection: Int = 2

    private var tabMapping: [String: Int] = [
        "Audio": 0,
        "History": 1,
        "Cleaner": 2,
        "Settings": 3
    ]

    // MARK: - Initializer
    
    init() {
        _settingsViewModel = StateObject(wrappedValue: SettingsViewModel(realmManager: RealmManager.shared))
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor( Color.background)

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.orange]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        ZStack {
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
            .background(Color.background)
            .onAppear {
                if let savedTabIndex = tabMapping[settingsViewModel.selectedTab] {
                    tabSelection = savedTabIndex
                }
            }
            VStack {
                BannerView()
                    .environmentObject(bannerService)
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 44)
        }
    }

    // MARK: - Haptic Feedback

    private func triggerHapticFeedback() {
        guard settingsViewModel.isHapticsEnabled else { return }
        let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactGenerator.impactOccurred()
    }
    
    private func showBannerForSave() {
        bannerService.setBanner(banner: .success(message: "Record saved successfully!"))
    }
    
    private func showBannerForClearHistory() {
        bannerService.setBanner(banner: .info(message: "History cleared."))
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RealmManager.shared)
            .environmentObject(BannerService())
    }
}

