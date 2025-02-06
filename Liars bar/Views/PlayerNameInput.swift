//
//  PlayerNameInput.swift
//  Liars bar
//
//  Created by 김동준 on 2/5/25.
//

import SwiftUI

struct PlayerNameInput: View {
    let index: Int
    @Binding var name: String
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle")
                .foregroundColor(.gray)
            TextField("플레이어 이름 입력", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
    }
}
