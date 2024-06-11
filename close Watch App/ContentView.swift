//
//  ContentView.swift
//  close Watch App
//
//  Created by Erik Wasmosy on 2024-06-11.
//

import SwiftUI

import Combine

class AnimationModel: ObservableObject {
    @Published var heartSize: CGFloat = 0.0
    @Published var heartOffset: CGSize = CGSize(width: 0, height: 0)
    @Published var isAnimating = false
    @Published var showConfirmation = false
    @Published var confirmationOpacity: Double = 1.0
    
    func startAnimation() {
        isAnimating = true
        heartSize = 0.0
        heartOffset = CGSize(width: 0, height: 20)

        withAnimation(.easeIn(duration: 0.5)) {
            heartSize = 40.0
            heartOffset = CGSize(width: 0, height: 0)
        }
        withAnimation(Animation.easeIn(duration: 1.5)) {
            heartSize = 50.0
            heartOffset = CGSize(width: 40, height: -20)
        }
        withAnimation(Animation.easeInOut(duration: 1.5).delay(1.0)) {
            heartSize = 60.0
            heartOffset = CGSize(width: -30, height: -50)
        }
        withAnimation(Animation.easeInOut(duration: 3.0).delay(2.0)) {
            heartSize = 70.0
            heartOffset = CGSize(width: 0, height: -150)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
            self.isAnimating = false
            self.simulateAPIResponse()
        }
    }

    func simulateAPIResponse() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.showConfirmation = true
            self.confirmationOpacity = 1.0
            self.hideConfirmation()
        }
    }
    
    func hideConfirmation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 1.0)) {
                self.confirmationOpacity = 0.0
            }
         
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showConfirmation = false
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var model = AnimationModel()

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                if model.isAnimating {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: model.heartSize, height: model.heartSize)
                        .foregroundColor(.red)
                        .offset(model.heartOffset)
                }

                Button(action: {
                    model.startAnimation()
                }) {
                    Text("Send Heart")
                        .foregroundStyle(Color.red)
                }
                .buttonStyle(BorderedButtonStyle())
                .padding()

                Spacer()
            }

            if model.showConfirmation {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green)
                    .frame(width: 100, height: 100)
                    .opacity(model.confirmationOpacity)
                    .overlay(
                        VStack {
                            Image(systemName: "checkmark")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Text("Sent")
                                .foregroundColor(.white)
                                .font(.body)
                        }
                    )
                    .transition(.scale)
            }
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    ContentView()
}
