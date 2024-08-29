//
//  BannerService.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 28.08.2024.
//

import Combine
import SwiftUI

class BannerService: ObservableObject {
    @Published var bannerType: BannerType? = nil

    func setBanner(banner: BannerType) {
        self.bannerType = banner
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hideBanner()
        }
    }

    func hideBanner() {
        self.bannerType = nil
    }
}




