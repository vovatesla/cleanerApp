//
//  CleanerView.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI

struct CleanerView: View {
    @StateObject private var viewModel = CleanerViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            Text("Cleaner")
                .bold()
                .font(.title2)
                .foregroundColor(.white)
                .padding(.top, 16)
                .padding(.bottom, 8)
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            Spacer()
            
            // MARK: - Toggle Button
            Button(action: viewModel.toggleBlower) {
                ZStack {
                    Circle()
                        .fill(viewModel.isActive ? Color.orange : Color.blue)
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "power.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            // MARK: - Status and Progress
            if viewModel.isActive {
                VStack(spacing: 8) {
                    Text("It is highly recommended to use cleaner only for 10 seconds!")
                        .foregroundColor(viewModel.isWarningVisible ? .red : .white)
                        .padding()
                        .transition(.opacity)
                    
                    ProgressBar(progress: Double(10 - viewModel.secondsRemaining) / 10.0)
                        .frame(height: 10)
                        .padding()
                }
                .transition(.opacity)
            } else {
                Text("Tap the button above to activate or deactivate blower")
                    .padding()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 37/255, green: 31/255, blue: 69/255))
        .foregroundColor(.white)
        .onDisappear {
            viewModel.stopBlower()
        }
    }
}

