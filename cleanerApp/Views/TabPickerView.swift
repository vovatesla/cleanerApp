//
//  TabPickerView.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI

struct TabPickerView: View {
    @Binding var selectedTab: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 0) {
                        // Iterate through the list of tabs and create a button for each
                        ForEach(["Audio", "History", "Cleaner", "Settings"], id: \.self) { tab in
                            tabOption(tab)
                        }
                    }
                    .padding()
                }
                .background(Color(red: 37/255, green: 31/255, blue: 69/255))
            }
            .navigationTitle("Choose Tab")
            .onAppear {
                configureNavigationBarAppearance()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
    }

    // MARK: - Private Methods

    /// Creates a button view for a tab option
    private func tabOption(_ tab: String) -> some View {
        Button(action: { selectTab(tab) }) {
            HStack {
                Text(tab)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
                if selectedTab == tab {
                    Image(systemName: "checkmark")
                        .foregroundColor(.orange)
                }
            }
            .padding()
            .background(selectedTab == tab ? Color.white.opacity(0.2) : Color.clear)
            .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }

    /// Updates the selected tab and dismisses the view
    private func selectTab(_ tab: String) {
        selectedTab = tab
        dismiss()
    }

    /// Configures the appearance of the navigation bar
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 37/255, green: 31/255, blue: 69/255, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

