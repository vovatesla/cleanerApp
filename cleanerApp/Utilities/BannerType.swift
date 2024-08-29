//
//  BannerType.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 28.08.2024.
//

import SwiftUI

enum BannerType: Equatable {
    case success(message: String)
    case info(message: String)

    var backgroundColor: Color {
        switch self {
        case .success: return Color.green
        case .info: return Color.blue
        }
    }

    var imageName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }

    var message: String {
        switch self {
        case let .success(message), let .info(message):
            return message
        }
    }
}


