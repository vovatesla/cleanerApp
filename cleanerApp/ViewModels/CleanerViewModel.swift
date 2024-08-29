//
//  CleanerViewModel.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI
import AVFoundation

class CleanerViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var isActive = false
    @Published var secondsRemaining = 0
    @Published var isWarningVisible = false

    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?

    // MARK: - Initializer
    
    init() {
        setupAudioPlayer()
    }

    // MARK: - Audio Player Setup
    
    private func setupAudioPlayer() {
        guard let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") else {
            print("Failed to find sound file.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to initialize AVAudioPlayer: \(error.localizedDescription)")
        }
    }

    // MARK: - Blower Control
    
    func toggleBlower() {
        isActive ? stopBlower() : startBlower()
    }

    private func startBlower() {
        guard !isActive else { return }

        // Reset timer and state
        timer?.invalidate()
        timer = nil
        isActive = true
        secondsRemaining = 10
        isWarningVisible = false

        // Prepare and play audio
        if let player = audioPlayer {
            if !player.isPlaying {
                player.currentTime = 0
                player.play()
            }
        } else {
            setupAudioPlayer()
            audioPlayer?.play()
        }

        // Start countdown timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
            } else {
                self.stopBlower()
            }
        }
    }

    func stopBlower() {
        guard isActive else { return }

        isActive = false

        // Stop audio and timer
        timer?.invalidate()
        timer = nil

        if let player = audioPlayer, player.isPlaying {
            player.stop()
        }

        // Show warning animation
        withAnimation(.easeInOut(duration: 1.0)) {
            isWarningVisible = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 1.0)) {
                self.isWarningVisible = false
            }
        }
    }
}


