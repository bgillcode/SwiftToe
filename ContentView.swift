import SwiftUI

struct ContentView: View {
    @ObservedObject var game = SwiftToeGame()
    @ObservedObject var audioManager = AudioManager.shared
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geometry in
            let tileSize = min(geometry.size.width, geometry.size.height) / 3.5
            
            VStack(spacing: 10) {
                ForEach(0..<3) { i in
                    HStack(spacing: 10) {
                        ForEach(0..<3) { j in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    game.makeMove(x: i, y: j)
                                }
                            }) {
                                Text(game.board[i][j])
                                    .font(.system(size: tileSize * 0.3))
                                    .frame(width: tileSize, height: tileSize)
                                    .background(game.board[i][j] == "X" ? Color.blue.opacity(0.6) : game.board[i][j] == "O" ? Color.orange.opacity(0.6) : Color.gray)
                                    .foregroundColor(game.board[i][j] == "X" ? .white : game.board[i][j] == "O" ? .black : .white)
                            }
                            .scaleEffect(game.pressedTile?.x == i && game.pressedTile?.y == j ? 1.1 : 1)
                        }
                    }
                }
                Spacer()
                Text("Score: X - \(game.scoreX) | O - \(game.scoreO)")
                Text(game.message)
                Spacer()
                Text("Current Player: \(game.currentPlayer)")
            }
            .padding()
            .alert(isPresented: $game.showAlert) {
                Alert(title: Text(game.message),
                      message: Text("Do you want to play again?"),
                      primaryButton: .default(Text("Yes"), action: {
                    game.reset()
                }),
                      secondaryButton: .cancel(Text("No"), action: {
                    presentationMode.wrappedValue.dismiss()
                })
                )
            }
        }
        .onAppear {
            game.newGame()
            audioManager.playBackgroundMusic()
        }
        .navigationBarItems(trailing:
            Button(action: {
                audioManager.toggleMute()
            }) {
                Image(systemName: audioManager.isMuted ? "speaker.slash.fill" : "speaker.fill")
                    .padding()
            }
        )
    }
}
