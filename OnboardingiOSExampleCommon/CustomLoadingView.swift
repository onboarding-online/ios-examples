//
//  CustomLoadingView.swift
//  OnboardingiOSExampleAppSwiftUI
//
//  Created by Oleg Kuplin on 08.12.2023.
//

import SwiftUI
import Combine

struct CustomLoadingView: View {
    var body: some View {
        VStack {
            LoadingText()
            LoadingDoubleHelix(color: .blue)
        }
    }
}

// MARK: - Private methods
private extension CustomLoadingView {
    struct LoadingText: View {
        let items: [String] = "My beautiful loading screen".map { String($0) }
        
        let timer: Publishers.Autoconnect<Timer.TimerPublisher>
        let timing: Double
        
        var maxCounter: Int { items.count }
        @State var counter = 0
        
        let frame: CGSize
        let primaryColor: Color
        
        init(color: Color = .black, size: CGFloat = 50, speed: Double = 0.5) {
            timing = speed / 4
            timer = Timer.publish(every: timing, on: .main, in: .common).autoconnect()
            frame = CGSize(width: size, height: size)
            primaryColor = color
        }
        
        var body: some View {
            HStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    Text(items[index])
                        .foregroundColor(primaryColor)
                        .font(.system(size: frame.height / 3, weight: .semibold, design: .default))
                        .offset(y: counter == index ? -frame.height / 8 : 0)
                }
            }
            .frame(height: frame.height, alignment: .center)
            .onReceive(timer, perform: { _ in
                withAnimation(Animation.spring()) {
                    counter = counter == (maxCounter - 1) ? 0 : counter + 1
                }
            })
        }
    }
    
    struct LoadingDoubleHelix: View {
        @State var isAnimating: Bool = false
        let timing: Double
        
        let maxCounter: Int = 10
        
        let frame: CGSize
        let primaryColor: Color
        
        init(color: Color = .black, size: CGFloat = 50, speed: Double = 0.5) {
            timing = speed * 2
            frame = CGSize(width: size, height: size)
            primaryColor = color
        }
        
        var body: some View {
            ZStack {
                HStack(spacing: frame.width / 40) {
                    ForEach(0..<maxCounter, id: \.self) { index in
                        
                        Circle()
                            .fill(primaryColor)
                            .offset(y: isAnimating ? frame.height / 6 : -frame.height / 6)
                            .animation(
                                Animation
                                    .easeInOut(duration: timing)
                                    .repeatForever(autoreverses: true)
                                    .delay(timing / Double(maxCounter) * Double(index))
                            )
                            .scaleEffect(isAnimating ? 1.0 : 0.8)
                            .opacity(isAnimating ? 1.0 : 0.8)
                            .animation(Animation.easeInOut(duration: timing).repeatForever(autoreverses: true))
                        
                    }
                }
                
                HStack(spacing: frame.width / 40) {
                    ForEach(0..<maxCounter, id: \.self) { index in
                        
                        Circle()
                            .fill(primaryColor)
                            .offset(y: isAnimating ? -frame.height / 6 : frame.height / 6)
                            .animation(
                                Animation
                                    .easeInOut(duration: timing)
                                    .repeatForever(autoreverses: true)
                                    .delay(timing / Double(maxCounter) * Double(index))
                            )
                            .scaleEffect(isAnimating ? 0.8 : 1.0)
                            .opacity(isAnimating ? 0.8 : 1.0)
                            .animation(Animation.easeInOut(duration: timing).repeatForever(autoreverses: true))
                        
                    }
                }
                
            }
            .frame(width: frame.width, height: frame.height, alignment: .center)
            .onAppear {
                isAnimating.toggle()
            }
        }
    }
}


#Preview {
    CustomLoadingView()
}
