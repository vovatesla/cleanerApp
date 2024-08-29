//
//  AudioViewModel.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import Foundation
import AVFoundation
import RealmSwift

class AudioViewModel: ObservableObject {

    // MARK: - Properties
    
    private var realm: Realm
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    
    @Published var isRecording = false
    @Published var currentLevel: Float = 0.0
    @Published var secondsRemaining = 0
    @Published var isWarningVisible = false

    private var recordedLevels: [Float] = []

    // MARK: - Initializer
    
    init(realm: Realm) {
        self.realm = realm
        setupAudioPlayer()
    }

    // MARK: - Audio Player
    
    func setupAudioPlayer() {
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

    // MARK: - Recording Control
    
    func startRecording() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatAppleLossless),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileURL = documentDirectory.appendingPathComponent("recording.m4a")

        do {
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            isRecording = true
            recordedLevels = []
            startTimer()
            print("Recording started")
        } catch {
            print("Error starting recording: \(error)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        stopTimer()
        print("Recording stopped")
        saveMeasurement()
    }

    // MARK: - Timer
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.audioRecorder?.updateMeters()
            self.currentLevel = self.audioRecorder?.averagePower(forChannel: 0) ?? 0.0
            self.recordedLevels.append(self.currentLevel) // Append the current level
        }
    }

    private func stopTimer() {
        timer?.invalidate()
    }

    // MARK: - Data Handling
    
    private func saveMeasurement() {
        let measurement = SoundMeasurement()
        measurement.date = Date()
        measurement.id = UUID().uuidString
        measurement.values = try? JSONEncoder().encode(recordedLevels)

        do {
            try realm.write {
                realm.add(measurement)
                print("Measurement saved: \(measurement)")
            }
        } catch {
            print("Failed to save measurement: \(error)")
        }
    }

    // MARK: - Microphone Access
    
    func requestMicrophoneAccess() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Microphone access granted")
            } else {
                print("Microphone access denied")
            }
        }
    }
}
