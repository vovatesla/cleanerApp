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
        if isActive {
            stopBlower()
        } else {
            startBlower()
        }
    }

    private func startBlower() {
        timer?.invalidate()
        timer = nil

        isActive = true
        secondsRemaining = 10
        isWarningVisible = false

        audioPlayer?.currentTime = 0
        audioPlayer?.play() // Запуск воспроизведения

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
            } else {
                self.stopBlower()
            }
        }
    }

    func stopBlower() {
        isActive = false

        timer?.invalidate()
        timer = nil

        audioPlayer?.stop() // Остановка воспроизведения

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

