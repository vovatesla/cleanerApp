//
//  RateAppView.swift
//  cleanerApp
//
//  Created by Бадретдинов Владимир on 29.08.2024.
//

import SwiftUI

struct RateAppView: View {
    @Binding var isPresented: Bool
    @State private var rating: Int = 0

    private var feedbackText: String {
        switch rating {
        case 1:
            return "We're sorry to hear that."
        case 2:
            return "We appreciate your feedback."
        case 3:
            return "Thanks for your rating!"
        case 4:
            return "Glad you like it!"
        case 5:
            return "Thank you! We're thrilled!"
        default:
            return "Please rate our app."
        }
    }

    private var emoji: String {
        switch rating {
        case 1:
            return "😢"
        case 2:
            return "😞"
        case 3:
            return "😊"
        case 4:
            return "😃"
        case 5:
            return "😍"
        default:
            return "🤔"
        }
    }

    var body: some View {
        VStack {
            Text(emoji)
                .font(.system(size: 100))
                .padding()

            Text(feedbackText)
                .font(.title2)
                .padding()
                .foregroundStyle(.white)

            HStack {
                ForEach(1..<6) { star in
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            rating = star
                        }
                }
            }
            .padding()

            Button(action: {
                isPresented = false
            }) {
                Text("Submit")
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .background(Color.background)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
        .ignoresSafeArea(.all)
        
    }
}
