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
    @EnvironmentObject private var bannerService: BannerService
    @StateObject private var audioManager: AudioViewModel

    // MARK: - Initializer

    init() {
        _audioManager = StateObject(wrappedValue: AudioViewModel(realm: RealmManager.shared.realm))
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                Spacer()

                content
                    .padding(.top, 16)
                    .padding(.bottom, 16)

                Spacer()
            }
            .background(Color(red: 37/255, green: 31/255, blue: 69/255))
            .foregroundColor(.white)
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            audioManager.requestMicrophoneAccess()
        }
        .onDisappear {
            if audioManager.isRecording {
                audioManager.stopRecording()
            }
            audioManager.currentLevel = 0
        }
    }

    // MARK: - Components

    private var header: some View {
        VStack(spacing: 0) {
            Text("Audio")
                .bold()
                .font(.title2)
                .foregroundColor(.white)
                .padding(.top, 16)
                .padding(.bottom, 8)
            Divider()
                .background(Color.white.opacity(0.3))
        }
        .padding(.horizontal)
    }

    private var content: some View {
        VStack(spacing: 16) {
            Text("Any value around -120 dB can be considered silence or very quiet.\n\nValues closer to 0 dB would mean louder sounds, with 0 dB being the loudest level the microphone can capture without distortion.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)

            SoundLevelRing(value: audioManager.currentLevel)
                .frame(width: 200, height: 200)
                .padding()

            Text("Current Level: \(String(format: "%.0f", audioManager.currentLevel)) dB")
                .font(.title3)

            ZStack {
                startRecordingButton
                    .opacity(audioManager.isRecording ? 0 : 1)
                    .animation(.easeInOut(duration: 0.3), value: audioManager.isRecording)

                recordingActions
                    .opacity(audioManager.isRecording ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: audioManager.isRecording)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 16)
        }
        .padding(.horizontal)
    }

    private var recordingActions: some View {
        VStack(spacing: 16) {
            Button(action: { audioManager.stopRecording() }) {
                Text("Stop Recording")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .font(.headline)
            }

            Button(action: {
                audioManager.stopRecording()
                bannerService.setBanner(banner: .success(message: "Record saved successfully!"))
            }) {
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

// MARK: - PreviewProvider

struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
        let realmManager = RealmManager.createPreviewManager()

        return AudioView()
            .environmentObject(realmManager)
            .environmentObject(BannerService())
    }
}
