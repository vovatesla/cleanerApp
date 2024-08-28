//
//  HistoryViewModel.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI
import RealmSwift

class HistoryViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var measurements: [SoundMeasurement] = []
    private var realm: Realm
    private var notificationToken: NotificationToken?

    // MARK: - Initializer
    
    init(realm: Realm) {
        self.realm = realm
        loadMeasurements()
        setupRealmNotification()
    }

    // MARK: - Data Loading
    
    private func loadMeasurements() {
        let results = realm.objects(SoundMeasurement.self)
            .sorted(byKeyPath: "date", ascending: false)
        measurements = Array(results)
    }

    // MARK: - Realm Notifications
    
    private func setupRealmNotification() {
        let results = realm.objects(SoundMeasurement.self)
            .sorted(byKeyPath: "date", ascending: false)
        
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let initialResults):
                self?.measurements = Array(initialResults)
            case .update(let updatedResults, _, _, _):
                self?.measurements = Array(updatedResults)
            case .error(let error):
                print("Error observing Realm changes: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Deinitialization
    
    deinit {
        notificationToken?.invalidate()
    }
}
