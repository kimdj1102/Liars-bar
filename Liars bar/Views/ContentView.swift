import SwiftUI

struct RevolverState {
    var playerName: String
    var bulletPosition: Int
    var currentPosition: Int
    var remainingChambers: Int
    var fired: Bool
    
    var probability: Double {
        return remainingChambers > 0 ? (1.0 / Double(remainingChambers)) * 100 : 0
    }
}

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

struct RevolverCylinder: View {
    let revolverState: RevolverState
    let onTrigger: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text(revolverState.playerName)
                .font(.headline)
                .foregroundColor(.blue)
            
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.8))
                    .frame(width: 120, height: 120)
                
                ForEach(0..<6) { index in
                    Circle()
                        .fill(Color.black.opacity(0.8))
                        .frame(width: 20, height: 20)
                        .offset(
                            x: 40 * cos(Double(index) * .pi / 3),
                            y: 40 * sin(Double(index) * .pi / 3)
                        )
                }
                
                Circle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 30, height: 30)
            }
            .background(
                Circle()
                    .fill(revolverState.fired ? Color.red.opacity(0.3) : Color.red.opacity(0.1))
                    .frame(width: 130, height: 130)
            )
            
            Text("\(revolverState.remainingChambers)/6개의 방이 남았습니다")
                .font(.subheadline)
            Text("사망 확률: \(String(format: "%.2f", revolverState.probability))%")
                .font(.subheadline)
            
            Button(action: onTrigger) {
                Text("방아쇠 당기기")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(revolverState.fired ? Color.gray : Color.red)
                    .cornerRadius(8)
            }
            .disabled(revolverState.fired)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var revolverStates: [RevolverState] = []
    @State private var numberOfRevolvers = 4
    @State private var message = ""
    @State private var showMessage = false
    @State private var displayCard = "Ace"
    @State private var gameOver = false
    @State private var showPlayerSetup = true
    @State private var playerNames: [String] = Array(repeating: "", count: 10)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("러시안 룰렛 시뮬레이터")
                    .font(.title)
                    .padding(.top)
                
                if showPlayerSetup {
                    setupView
                } else {
                    gameView
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .onAppear {
            resetGame()
        }
    }
    
    var setupView: some View {
        VStack(spacing: 20) {
            Text("게임 설정")
                .font(.title2)
            
            VStack(alignment: .leading) {
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
            .padding()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("플레이어 이름")
                    .font(.headline)
                
                ForEach(0..<numberOfRevolvers, id: \.self) { index in
                    PlayerNameInput(index: index, name: $playerNames[index])
                }
            }
            .padding()
            
            Button(action: startGame) {
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
    
    var gameView: some View {
        VStack(spacing: 20) {
            if showMessage {
                Text(message)
                    .font(.headline)
                    .foregroundColor(message.contains("탕!") ? .red : .green)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
            
            // 테이블 카드 섹션
            VStack(alignment: .leading, spacing: 10) {
                Text("테이블 카드")
                    .font(.headline)
                    .padding(.horizontal)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 80, height: 120)
                        .shadow(radius: 2)
                    
                    Text(displayCard)
                        .font(.title)
                }
                
                HStack(spacing: 10) {
                    Button(action: drawRandomCard) {
                        Text("무작위 카드 뽑기")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 8) {
                        Button(action: resetGame) {
                            Text("새 게임")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        Button(action: resetRevolvers) {
                            Text("리볼버 초기화")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                
                LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 20) {
                                ForEach(0..<revolverStates.count, id: \.self) { index in
                                    RevolverCylinder(
                                        revolverState: revolverStates[index],
                                        onTrigger: { shootGun(at: index) }
                                    )
                                }
                            }
                            .padding()
            }
        }
    }
    
    func startGame() {
        revolverStates = (0..<numberOfRevolvers).map { index in
            let name = playerNames[index].isEmpty ? "플레이어 \(index + 1)" : playerNames[index]
            return RevolverState(
                playerName: name,
                bulletPosition: Int.random(in: 0...5),
                currentPosition: 0,
                remainingChambers: 6,
                fired: false
            )
        }
        showPlayerSetup = false
    }
    
    func shootGun(at index: Int) {
        var state = revolverStates[index]
        
        if state.currentPosition == state.bulletPosition {
            state.fired = true
            message = "탕! \(state.playerName) 사망!"
            gameOver = true
        } else {
            state.currentPosition = (state.currentPosition + 1) % 6
            state.remainingChambers -= 1
            message = "찰칵! \(state.playerName) 생존"
        }
        
        revolverStates[index] = state
        showMessage = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showMessage = false
        }
    }
    
    func resetRevolvers() {
        revolverStates = revolverStates.map { state in
            RevolverState(
                playerName: state.playerName,
                bulletPosition: Int.random(in: 0...5),
                currentPosition: 0,
                remainingChambers: 6,
                fired: false
            )
        }
        message = ""
        showMessage = false
        gameOver = false
    }
    
    func resetGame() {
        showPlayerSetup = true
        gameOver = false
        message = ""
        showMessage = false
        playerNames = Array(repeating: "", count: 10)
    }
    
    func drawRandomCard() {
        let cards = ["Ace", "King", "Queen"]
        displayCard = cards.randomElement() ?? "Ace"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
