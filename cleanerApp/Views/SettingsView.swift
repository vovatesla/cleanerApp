//
//  SettingsView.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var realmManager: RealmManager
    @EnvironmentObject private var bannerService: BannerService
    @StateObject private var viewModel: SettingsViewModel
    
    @State private var showTabPicker: Bool = false
    @State private var showRateAppView: Bool = false
    @State private var isButtonPressed: Bool = false
    
    init() {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(realmManager: RealmManager.shared))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
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
                .background(Color.background)
                
                List {
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
                        .listRowBackground(Color.background)
                    
                    Section(header: Text("Community")
                        .font(.subheadline)
                        .foregroundColor(.white)) {
                            Button(action: {
                                showRateAppView.toggle()
                            }) {
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
                            .sheet(isPresented: $showRateAppView) {
                                ZStack{
                                    Color.background
                                    RateAppView(isPresented: $showRateAppView)
                                }
                                .ignoresSafeArea()
                            }
                            
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
                        .listRowBackground(Color.background)
                    
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
                        .listRowBackground(Color.background)
                    
                    Section(header: Text("History")
                        .font(.subheadline)
                        .foregroundColor(.white)) {
                            Button(action: {
                                print("Clear History button pressed.")
                                viewModel.clearHistory()
                                bannerService.setBanner(banner: .info(message: "History cleared."))
                            }) {
                                Text("Clear History")
                                    .bold()
                                    .foregroundColor(Color.background)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                                    .animation(.easeOut(duration: 0.2), value: isButtonPressed)
                            }
                        }
                        .listRowBackground(Color.background)
                }
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden)
            }
            .background(Color.background)
        }
    }
}


// MARK: - PreviewProvider

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(RealmManager.shared)
            .environmentObject(BannerService())
    }
    
}
