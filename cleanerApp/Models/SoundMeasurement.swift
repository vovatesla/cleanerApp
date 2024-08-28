//
//  SoundMeasurement.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import Foundation
import RealmSwift

class SoundMeasurement: Object, Identifiable {
    
    // MARK: - Properties
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var date: Date = Date()
    @objc dynamic var values: Data? // Используйте Data для хранения закодированных значений

    // MARK: - Primary Key
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Computed Properties
    
    var maxLevel: Float? {
        guard let valuesData = values else { return nil }
        let valuesArray = try? JSONDecoder().decode([Float].self, from: valuesData)
        return valuesArray?.max()
    }
    
    var minLevel: Float? {
        guard let valuesData = values else { return nil }
        let valuesArray = try? JSONDecoder().decode([Float].self, from: valuesData)
        return valuesArray?.min()
    }
    
    var avgLevel: Float? {
        guard let valuesData = values else { return nil }
        let valuesArray = try? JSONDecoder().decode([Float].self, from: valuesData)
        let sum = valuesArray?.reduce(0, +) ?? 0
        return valuesArray?.isEmpty == true ? nil : sum / Float(valuesArray?.count ?? 1)
    }
    
    var duration: TimeInterval {
        // Учитываем, что запись длится ровно 10 секунд
        return 10
    }
}
