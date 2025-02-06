//
//  RevolverSylinder.swift
//  Liars bar
//
//  Created by 김동준 on 2/5/25.
//

import SwiftUI

struct CylinderHole: View {
    let index: Int
    let isRed: Bool
    
    var body: some View {
        Circle()
            .fill(isRed ? Color.red : Color.black.opacity(0.8))
            .frame(width: 20, height: 20)
            .offset(
                x: 40 * cos(Double(index) * .pi / 3),
                y: 40 * sin(Double(index) * .pi / 3)
            )
    }
}

struct RevolverCylinder: View {
    let revolverState: RevolverState
    let onTrigger: (Double) -> Void  // 애니메이션 시간을 매개변수로 전달
    let message: String
    let showMessage: Bool
    
    @State private var rotation: Double = 0
    private let animationDuration: Double = 2.0  // 애니메이션 시간을 2초로 설정
    
    var messageOverlay: some View {
        Group {
            if showMessage {
                Text(message)
                    .font(.headline)
                    .foregroundColor(message.contains("탕!") ? .red : .green)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(8)
            }
        }
    }
    
    var cylinderHoles: some View {
        ForEach(0..<6) { index in
            CylinderHole(
                index: index,
                isRed: revolverState.redHoles.contains(index)
            )
        }
    }
    
    var triggerButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: animationDuration)) {
                rotation += 720  // 두 바퀴 돌리기
            }
            onTrigger(animationDuration)
        }) {
            Text("방아쇠 당기기")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(revolverState.fired ? Color.gray : Color.red)
                .cornerRadius(8)
        }
        .disabled(revolverState.fired)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text(revolverState.playerName)
                .font(.headline)
                .foregroundColor(.blue)
            
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.8))
                    .frame(width: 120, height: 120)
                
                cylinderHoles
                    .rotationEffect(.degrees(rotation))
                
                Circle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 30, height: 30)
                
                messageOverlay
            }
            .background(
                Circle()
                    .fill(revolverState.fired ? Color.red.opacity(0.3) : Color.red.opacity(0.1))
                    .frame(width: 130, height: 130)
            )
            
            Text("\(revolverState.remainingChambers)/6개 방 남음")
                .font(.subheadline)
            Text("사망 확률: \(String(format: "%.2f", revolverState.probability))%")
                .font(.subheadline)
            
            triggerButton
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
