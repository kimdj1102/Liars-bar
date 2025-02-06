//
//  GameSetupView.swift
//  Liars bar
//
//  Created by 김동준 on 2/5/25.
//

import SwiftUI

struct GameSetupView: View {
    @Binding var numberOfRevolvers: Int
    @Binding var playerNames: [String]
    let onStartGame: () -> Void
    
    var body: some View {
        VStack() {
            VStack(alignment: .center, spacing: 5) {
                Text("플레이어 수")
                    .font(.headline)

                HStack {
                    Button(action: { if numberOfRevolvers > 1 { numberOfRevolvers -= 1 } }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    
                    Text("\(numberOfRevolvers)")
                        .font(.title2)
                        .frame(width: 50)
                    
                    Button(action: { if numberOfRevolvers < 6 { numberOfRevolvers += 1 } }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                Divider()
                
                Text("플레이어 이름")
                    .font(.headline)
                
                ForEach(0..<numberOfRevolvers, id: \.self) { index in
                    PlayerNameInput(index: index, name: $playerNames[index])
                }
            }
            .padding()
            
            Button(action: onStartGame) {
                Text("게임 시작")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
