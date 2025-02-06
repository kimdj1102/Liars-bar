//
//  CardSectionView.swift
//  Liars bar
//
//  Created by 김동준 on 2/5/25.
//

import SwiftUI

struct CardSectionView: View {
    let displayCard: String
    let onDrawCard: () -> Void
    let onNewGame: () -> Void
    let onResetRevolvers: () -> Void
    @State private var isRotating = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // 왼쪽: 테이블 카드 섹션
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 170, height: 120)
                        .shadow(radius: 2)
                    
                    Text(displayCard)
                        .rotation3DEffect(
                            .degrees(isRotating ? 360 : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0))
                        .animation(.easeIn(duration: 1.5), value: isRotating)
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // 오른쪽: 버튼 섹션
            VStack(spacing: 10) {
                Button(action: {
                    isRotating.toggle()
                    onDrawCard()
                }) {
                    Text("무작위 카드 뽑기")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                Button(action: onResetRevolvers) {
                    Text("리볼버 초기화")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}
