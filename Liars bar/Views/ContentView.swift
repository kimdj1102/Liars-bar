import SwiftUI

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
                Text("Liar's bar")
                    .font(.title)
                    .padding(.top)
                
                if showPlayerSetup {
                    GameSetupView(
                        numberOfRevolvers: $numberOfRevolvers,
                        playerNames: $playerNames,
                        onStartGame: startGame
                    )
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
    
    var gameView: some View {
        VStack(spacing: 5) {
            CardSectionView(
                displayCard: displayCard,
                onDrawCard: drawRandomCard,
                onNewGame: resetGame,
                onResetRevolvers: resetRevolvers
            )
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(0..<revolverStates.count, id: \.self) { index in
                    RevolverCylinder(
                        revolverState: revolverStates[index],
                        onTrigger: { animationDuration in
                            // 애니메이션이 끝난 후 결과 처리
                            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                                shootGun(at: index)
                            }
                        },
                        message: revolverStates[index].message,
                        showMessage: revolverStates[index].showMessage
                    )
                }
            }
            .padding()
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
                fired: false,
                message: "",
                showMessage: false
            )
        }
        showPlayerSetup = false
    }
    
    func shootGun(at index: Int) {
        var state = revolverStates[index]
        
        if state.currentPosition == state.bulletPosition {
            // 사망 시
            state.fired = true
            state.addRandomRedHole()
            state.message = "탕! \(state.playerName) 사망!"
            state.showMessage = true
            gameOver = true
        } else {
            // 생존 시
            state.currentPosition = (state.currentPosition + 1) % 6
            state.remainingChambers -= 1
            state.addRandomRedHole()
            state.message = "찰칵! \(state.playerName) 생존"
            state.showMessage = true
            
            // 생존한 경우에만 3초 후 메시지 숨김
            let currentIndex = index  // 클로저에서 사용하기 위한 복사
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if !revolverStates[currentIndex].message.contains("탕!") {
                    var updatedState = revolverStates[currentIndex]
                    updatedState.showMessage = false
                    revolverStates[currentIndex] = updatedState
                }
            }
        }
        
        revolverStates[index] = state
    }
    
    func resetGame() {
        showPlayerSetup = true
        gameOver = false
        message = ""
        showMessage = false
        playerNames = Array(repeating: "", count: 10)
    }
    
    func resetRevolvers() {
        revolverStates = revolverStates.map { state in
            RevolverState(
                playerName: state.playerName,
                bulletPosition: Int.random(in: 0...5),
                currentPosition: 0,
                remainingChambers: 6,
                fired: false,
                message: "",
                showMessage: false,
                redHoles: []  // 빨간 구멍 초기화
            )
        }
        gameOver = false
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
