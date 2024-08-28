//
//  AudioView.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI
import RealmSwift
import AVFoundation

struct AudioView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var realmManager: RealmManager
    @StateObject private var audioManager: AudioManager
    @State private var showSavedNotification = false

    // MARK: - Initializer
    
    init() {
        // Инициализируем AudioManager с экземпляром Realm из RealmManager
        _audioManager = StateObject(wrappedValue: AudioManager(realm: RealmManager.shared.realm))
    }

    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            header
            content
            notification
        }
        .onAppear {
            audioManager.requestMicrophoneAccess()
        }
        .onDisappear {
            if audioManager.isRecording {
                audioManager.stopRecording(save: false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 37/255, green: 31/255, blue: 69/255))
        .foregroundColor(.white)
    }
    
    // MARK: - Components
    
    private var header: some View {
        VStack {
            Text("Audio")
                .bold()
                .font(.title2)
                .foregroundColor(.white)
                .padding(.top, 16)
                .padding(.bottom, 8)

            Divider()
                .background(Color.white.opacity(0.3))
        }
    }
    
    private var content: some View {
        VStack {
            Text("Any value around -120 dB can be considered silence or very quiet.\n\nValues closer to 0 dB would mean louder sounds, with 0 dB being the loudest level the microphone can capture without distortion.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.white)

            SoundLevelRing(value: audioManager.currentLevel)
                .frame(width: 200, height: 200)
                .padding()

            Text("Current Level: \(String(format: "%.0f", audioManager.currentLevel)) dB")
                .font(.title3)
                .padding()

            if audioManager.isRecording {
                recordingActions
            } else {
                startRecordingButton
            }
        }
        .padding()
    }

    private var recordingActions: some View {
        VStack(spacing: 16) {
            RecordingActionButton(
                action1: { audioManager.stopRecording(save: false) },
                action2: {
                    audioManager.stopRecording(save: true)
                    withAnimation { showSavedNotification = true }
                }
            )
            .padding()
        }
    }

    private var startRecordingButton: some View {
        Button(action: {
            audioManager.startRecording()
        }) {
            Text("Start Recording")
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .frame(maxWidth: .infinity, minHeight: 50)
                .font(.headline)
        }
    }
    
    private var notification: some View {
        Group {
            if showSavedNotification {
                SavedNotificationView()
                    .transition(.slide)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSavedNotification = false
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - RecordingActionButton

struct RecordingActionButton: View {
    var action1: () -> Void
    var action2: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button(action: action1) {
                Text("Stop Recording")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .font(.headline)
            }

            Text("or")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.vertical, 8)

            Button(action: action2) {
                Text("Save")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .font(.headline)
            }
        }
    }
}

// MARK: - SoundLevelRing

struct SoundLevelRing: View {
    @State private var isAnimating = false
    var value: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 30)
                .opacity(0.1)
                .foregroundColor(Color.white)
            
            Circle()
                .trim(from: 0.0, to: isAnimating ? normalizedValue() : 0.0)
                .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .foregroundColor(Color.orange)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 0.5), value: isAnimating ? normalizedValue() : 0.0)
        }
        .onAppear {
            isAnimating = false
        }
        .onChange(of: value) { _ in
            isAnimating = true
        }
    }
    
    private func normalizedValue() -> CGFloat {
        let normalized = (value + 120) / 120
        return CGFloat(min(max(normalized, 0), 1))
    }
}

// MARK: - SavedNotificationView

struct SavedNotificationView: View {
    var body: some View {
        HStack {
            Text("Saved to History")
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - PreviewProvider

struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
        let realmManager = RealmManager.createPreviewManager() // Используем менеджер для предварительного просмотра

        return AudioView()
            .environmentObject(realmManager) // Предоставляем RealmManager как объект окружения
    }
}
