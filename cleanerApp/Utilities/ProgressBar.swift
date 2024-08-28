//
//  ProgressBar.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 27.08.2024.
//

import SwiftUI

struct ProgressBar: View {
    
    // MARK: - Properties
    
    var progress: Double
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 200, height: 10)
            
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.orange)
                .frame(width: CGFloat(progress) * 200, height: 10)
        }
    }
}

// MARK: - Preview

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 0.5)
    }
}

