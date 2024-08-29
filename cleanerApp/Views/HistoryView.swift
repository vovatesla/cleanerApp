//
//  HistoryView.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI
import RealmSwift

struct HistoryView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var realmManager: RealmManager
    @StateObject private var viewModel = HistoryViewModel()
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            header
            content
        }
        .background(Color(red: 37/255, green: 31/255, blue: 69/255))
        .foregroundColor(.white)
        .onAppear {
            viewModel.setRealm(realmManager.realm)
        }
    }
    
    // MARK: - Components
    
    private var header: some View {
        VStack {
            Text("History")
                .bold()
                .font(.title2)
                .foregroundColor(.white)
                .padding(.top, 16)
                .padding(.bottom, 8)
            Divider()
                .background(Color.white.opacity(0.3))
        }
    }

    private var content: some View {
        VStack {
            if viewModel.measurements.isEmpty {
                emptyState
            } else {
                measurementList
            }
        }
    }

    private var emptyState: some View {
        VStack {
            Spacer()
            Text("No data added yet")
                .font(.title)
                .padding()
            Spacer()
        }
    }

    private var measurementList: some View {
        ScrollView {
            ForEach(viewModel.measurements.indices, id: \.self) { index in
                SoundLevelChart(measurement: viewModel.measurements[index], index: index)
                    .padding(.top, 8)
            }
        }
    }
}

// MARK: - PreviewProvider

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "PreviewRealm"))
        return HistoryView()
            .environmentObject(RealmManager.createPreviewManager())
    }
}
