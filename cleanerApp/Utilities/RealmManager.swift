//
//  RealmManager.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import RealmSwift
import Combine

class RealmManager: ObservableObject {
    
    // MARK: - Properties
    
    static let shared = RealmManager()
    @Published var realm: Realm

    // MARK: - Initializer
    
    private init() {
        let realmConfig = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in

            }
        )
        Realm.Configuration.defaultConfiguration = realmConfig

        do {
            realm = try Realm()
            print("Realm initialized successfully")
        } catch {
            fatalError("Error initializing Realm: \(error.localizedDescription)")
        }
    }

    // MARK: - Preview
    
    static func createPreviewManager() -> RealmManager {
        let manager = RealmManager()
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "PreviewRealm"))
        manager.realm = realm
        return manager
    }

    // MARK: - Methods
    
    func addMeasurement(_ measurement: SoundMeasurement) {
        do {
            try realm.write {
                realm.add(measurement)
            }
            print("Measurement added successfully")
        } catch {
            print("Error adding measurement: \(error.localizedDescription)")
        }
    }
    
    func fetchMeasurements() -> Results<SoundMeasurement> {
        return realm.objects(SoundMeasurement.self)
    }

    func clearHistory() {
        do {
            try realm.write {
                let allMeasurements = realm.objects(SoundMeasurement.self)
                realm.delete(allMeasurements)
            }
            print("All measurements deleted")
        } catch {
            print("Error clearing history: \(error.localizedDescription)")
        }
    }
}
