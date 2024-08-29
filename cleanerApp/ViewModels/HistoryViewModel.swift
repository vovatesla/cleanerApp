//
//  HistoryViewModel.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import RealmSwift
import Combine
import SwiftUI

class HistoryViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var measurements: [SoundMeasurement] = []
    private var realm: Realm?
    private var token: NotificationToken?
    
    // MARK: - Initializer
    
    init() {
       
    }

    // MARK: - Methods
    
    func setRealm(_ realm: Realm) {
        self.realm = realm
        fetchMeasurements()
    }

    private func fetchMeasurements() {
        guard let realm = realm else { return }
        
        let measurementsResults = realm.objects(SoundMeasurement.self).sorted(byKeyPath: "date", ascending: false)
        measurements = Array(measurementsResults)
        
        token = measurementsResults.observe { [weak self] changes in
            switch changes {
            case .initial(let results):
                self?.measurements = Array(results)
            case .update(let results, _, _, _):
                self?.measurements = Array(results)
            case .error(let error):
                print("Error observing realm results: \(error.localizedDescription)")
            }
        }
    }

    
    deinit {
        token?.invalidate()
    }
}
