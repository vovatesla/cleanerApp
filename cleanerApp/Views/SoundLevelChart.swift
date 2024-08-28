//
//  SoundLevelChart.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI
import Charts
import RealmSwift

// MARK: - ChartDataPoint

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let x: Double
    let y: Double
}

// MARK: - SoundLevelChart

struct SoundLevelChart: View {
    var measurement: SoundMeasurement
    var index: Int

    var body: some View {
        VStack(alignment: .leading) {
            // MARK: - Header
            Text("Запись \(index + 1)")
                .font(.headline)
                .padding(.bottom, 5)

            // MARK: - Chart
            Chart {
                let values: [Double] = {
                    guard let valuesData = measurement.values else { return [] }
                    let valuesArray = try? JSONDecoder().decode([Float].self, from: valuesData)
                    return valuesArray?.map { Double($0) } ?? []
                }()

                let chartData = values.enumerated().map { index, value in
                    ChartDataPoint(x: Double(index), y: value)
                }

                ForEach(chartData) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.x),
                        y: .value("Level", dataPoint.y)
                    )
                    .foregroundStyle(Color.orange)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }

                if let maxValue = values.max(), let minValue = values.min() {
                    PointMark(
                        x: .value("Time", Double(values.firstIndex(of: maxValue) ?? 0)),
                        y: .value("Level", maxValue)
                    )
                    .foregroundStyle(Color.red)
                    .symbolSize(10)

                    PointMark(
                        x: .value("Time", Double(values.firstIndex(of: minValue) ?? 0)),
                        y: .value("Level", minValue)
                    )
                    .foregroundStyle(Color.blue)
                    .symbolSize(10)
                }
            }
            .frame(height: 200)

            // MARK: - Statistics Display
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if let valuesData = measurement.values,
                       let decodedValues = try? JSONDecoder().decode([Float].self, from: valuesData) {
                        let duration = Double(decodedValues.count)
                        let maxValue = decodedValues.max() ?? 0
                        let minValue = decodedValues.min() ?? 0
                        let avgValue = decodedValues.reduce(0, +) / Float(decodedValues.count)

                        Text("Max dB: \(String(format: "%.2f", maxValue))")
                            .font(.subheadline)
                            .foregroundColor(.red)
                        Text("Min dB: \(String(format: "%.2f", minValue))")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        Text("Avg dB: \(String(format: "%.2f", avgValue))")
                            .font(.subheadline)
                            .foregroundColor(.green)
                        Text("Duration: \(String(format: "%.0f", duration)) seconds")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                }
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

// MARK: - Preview

struct SoundLevelChart_Previews: PreviewProvider {
    static var previews: some View {
        let mockRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "PreviewRealm"))
        let measurement = SoundMeasurement()
        measurement.values = try? JSONEncoder().encode([Float(30), Float(40), Float(50), Float(60), Float(70)])
        return SoundLevelChart(measurement: measurement, index: 0)
            .environment(\.realm, mockRealm)
            .preferredColorScheme(.dark)
    }
}
