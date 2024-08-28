//
//  SettingsView.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var realmManager: RealmManager
    @StateObject private var viewModel: SettingsViewModel
    
    @State private var showTabPicker: Bool = false
    @State private var isButtonPressed: Bool = false
    
    init() {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(realmManager: RealmManager.shared))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Header
                VStack(spacing: 0) {
                    Text("Settings")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                }
                .background(Color(red: 37/255, green: 31/255, blue: 69/255))
                
                // MARK: - List
                List {
                    // MARK: - Customisation Section
                    Section(header: Text("Customisation")
                        .font(.subheadline)
                        .foregroundColor(.white)) {
                            Button(action: { showTabPicker.toggle() }) {
                                HStack {
                                    Image(systemName: "house")
                                        .foregroundColor(.white)
                                    Text("Primary Tab")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text(viewModel.selectedTab)
                                        .foregroundColor(.gray)
                                }
                            }
                            .sheet(isPresented: $showTabPicker) {
                                TabPickerView(selectedTab: $viewModel.selectedTab)
                            }
                            Divider()
                                .background(Color.white)
                            
                            Toggle(isOn: $viewModel.isHapticsEnabled) {
                                HStack {
                                    Image(systemName: "hand.raised")
                                        .foregroundColor(.white)
                                    Text("Haptics")
                                        .foregroundColor(.white)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .orange))
                        }
                        .listRowBackground(Color(red: 37/255, green: 31/255, blue: 69/255))
                    
                    // MARK: - Community Section
                    Section(header: Text("Community")
                        .font(.subheadline)
                        .foregroundColor(.white)) {
                            Link(destination: URL(string: "https://apps.apple.com")!) {
                                HStack {
                                    Image(systemName: "star")
                                        .foregroundColor(.white)
                                    Text("Rate Our App")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.orange)
                                }
                            }
                            Divider()
                                .background(Color.white)
                            
                            Link(destination: URL(string: "mailto:support@example.com")!) {
                                HStack {
                                    Image(systemName: "message.fill")
                                        .foregroundColor(.white)
                                    Text("Support")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        .listRowBackground(Color(red: 37/255, green: 31/255, blue: 69/255))
                    
                    // MARK: - Legal Section
                    Section(header: Text("Legal")
                        .font(.subheadline)
                        .foregroundColor(.white)) {
                            Link(destination: URL(string: "https://example.com/privacy-policy")!) {
                                HStack {
                                    Image(systemName: "person.crop.circle.badge.checkmark")
                                        .foregroundColor(.white)
                                    Text("Privacy Policy")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        .listRowBackground(Color(red: 37/255, green: 31/255, blue: 69/255))
                    
                    // MARK: - History Section
                    Section(header: Text("History")
                        .font(.subheadline)
                        .foregroundColor(.white)) {
                            Button(action: {
                                print("Clear History button pressed.")
                                isButtonPressed = true
                                viewModel.clearHistory()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isButtonPressed = false
                                }
                            }) {
                                Text("Clear History")
                                    .bold()
                                    .foregroundColor(Color(red: 37/255, green: 31/255, blue: 69/255))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                                    .animation(.easeOut(duration: 0.2), value: isButtonPressed)
                            }
                        }
                        .listRowBackground(Color(red: 37/255, green: 31/255, blue: 69/255))
                }
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden)
            }
            .background(Color(red: 37/255, green: 31/255, blue: 69/255))
        }
    }
}

