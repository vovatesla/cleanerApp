//
//  BannerView.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 28.08.2024.
//

import Combine
import SwiftUI

struct BannerView: View {
    @EnvironmentObject var bannerService: BannerService

    var body: some View {
        VStack {
            if let banner = bannerService.bannerType {
                HStack(spacing: 10) {
                    Image(systemName: banner.imageName)
                        .padding(5)
                        .background(banner.backgroundColor)
                        .cornerRadius(5)
                        .shadow(color: .black.opacity(0.2), radius: 3.0, x: -3, y: 4)
                    Text(banner.message)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                        .lineLimit(2)
                        .padding(.trailing, 10)
                }
                .padding(8)
                .background(banner.backgroundColor)
                .cornerRadius(10)
                .shadow(radius: 3.0, x: -2, y: 2)
                .transition(.move(edge: .top))
                .animation(.easeInOut)
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.horizontal)
        .padding(.top, 20)
    }
}


// MARK: - Preview

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        BannerView()
            .environmentObject(BannerService())
    }
}
