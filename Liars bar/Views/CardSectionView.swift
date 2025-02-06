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
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            // 왼쪽: 테이블 카드 섹션
            VStack(spacing: 10) {
                Text("테이블 카드")
                    .font(.headline)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 170, height: 150)
                        .shadow(radius: 2)
                    
                    Text(displayCard)
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 오른쪽: 버튼 섹션
            VStack(spacing: 10) {
                Button(action: onDrawCard) {
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
                
                Button(action: onNewGame) {
                    Text("새 게임")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
    }
}
