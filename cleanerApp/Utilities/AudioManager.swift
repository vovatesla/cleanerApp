//
//  AudioManager.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import AVFoundation
import RealmSwift
import UIKit

class AudioManager: ObservableObject {
    
    // MARK: - Properties
    
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var realm: Realm
    
    @Published var isRecording = false
    @Published var currentLevel: Float = 0.0
    
    private var recordedLevels = [Float]()
    
    // MARK: - Initializer
    
    init(realm: Realm) {
        self.realm = realm
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        setupAudioSession()
    }
    
    // MARK: - Audio Session
    
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    // MARK: - Recording
    
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
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            isRecording = true
            recordedLevels.removeAll()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.audioRecorder?.updateMeters()
                self.currentLevel = self.audioRecorder?.averagePower(forChannel: 0) ?? -120.0
                self.startTimer()
            }
        } catch {
            print("Error starting recording: \(error)")
        }
    }
    
    func stopRecording(save: Bool) {
        audioRecorder?.stop()
        isRecording = false
        stopTimer()
        
        if save {
            saveMeasurement()
        }
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.audioRecorder?.updateMeters()
            self.currentLevel = self.audioRecorder?.averagePower(forChannel: 0) ?? -120.0
            self.recordedLevels.append(self.currentLevel)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Saving Measurements
    
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
    
    // MARK: - Notifications
    
    @objc private func handleAppWillResignActive() {
        if isRecording {
            stopRecording(save: false)
        }
    }
}
