//
//  ContentView.swift
//  SwiftUI_task3
//
//  Created by Evgenii Mikhailov on 05.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State var scale = 0.0
    @State var scale2 = 1.0
    @State var opacity1 = 0.0
    @State var opacity2 = 1.0
    let imageSize = 18.0
    @State var isDisabled = false
    @State var duration = 0.22

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
                self.scale = 1.0
                self.scale2 = 0.0
                self.opacity2 = 0
                self.opacity1 = 1
            }


            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.scale = 0.0
                self.scale2 = 1.0
                self.opacity2 = 1
                self.opacity1 = 0
            }
        }) {
            HStack(spacing: 0) {
                Image("play")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.blue)
                    .frame(width: imageSize * scale, height: imageSize * scale)
                    .opacity(opacity1)
                Image("play")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.blue)
                    .frame(width: imageSize, height: imageSize)
                Image("play")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.blue)
                    .frame(width: imageSize * scale2, height: imageSize * scale2)
                    .opacity(opacity2)
            }
        }
        .disabled(isDisabled)
        .buttonStyle(PressableButtonStyle(animtaionLength: $duration))

    }
}

struct NoTapAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
    }
}

struct PressableButtonStyle: ButtonStyle {
    @State private var isAnimating: Bool = false
    @Binding var animtaionLength: Double

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundColor(Color.gray.opacity(0.25))
                .scaleEffect(isAnimating ? 1 : 0.86)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 65, height: 65)
                .animation(.easeOut(duration: animtaionLength), value: isAnimating)

            configuration.label
                .scaleEffect(isAnimating ? 0.86 : 1.0)
                .animation(.easeOut(duration: animtaionLength), value: isAnimating)
                .onChange(of: configuration.isPressed) { oldValue, newValue in
                    if oldValue {
                        isAnimating = true
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + animtaionLength) {
                            isAnimating = false
                        }
                    }
                }
        }
    }
}



#Preview {
    ContentView()
}
