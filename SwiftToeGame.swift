import SwiftUI
import AVFoundation

class SwiftToeGame: ObservableObject {
    @Published var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @Published var scoreX: Int = 0
    @Published var scoreO: Int = 0
    @Published var message: String = ""
    @Published var showAlert: Bool = false
    @Published var pressedTile: (x: Int, y: Int)? = nil
    var currentPlayer: String = "X"
    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        if let path = Bundle.main.path(forResource: "Storytelling-Essentials-Free-No-Copyright-Music-by-Liborio-Conti-01-Cinematic-Piano", ofType: ".mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.numberOfLoops = -1 // This will loop the audio indefinitely
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing background music")
            }
        }
    }
    
    func newGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        scoreX = 0
        scoreO = 0
        currentPlayer = "X"
        message = ""
    }
    
    func presentEndOfGameAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.showAlert = true
        }
    }
    
    func reset() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        currentPlayer = "X"
        message = ""
    }
    
    func makeMove(x: Int, y: Int) {
        if board[x][y] == "" {
            pressedTile = (x, y)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.board[x][y] = self.currentPlayer
                self.checkForWinner()
                self.currentPlayer = self.currentPlayer == "X" ? "O" : "X"
                self.pressedTile = nil
            }
        }
    }
    
    private func checkForWinner() {
        for i in 0..<3 {
            if board[i][0] == currentPlayer && board[i][1] == currentPlayer && board[i][2] == currentPlayer ||
               board[0][i] == currentPlayer && board[1][i] == currentPlayer && board[2][i] == currentPlayer {
                currentPlayer == "X" ? (scoreX += 1) : (scoreO += 1)
                message = "\(currentPlayer) Wins!"
                presentEndOfGameAlert()
                return
            }
        }
        
        if board[0][0] == currentPlayer && board[1][1] == currentPlayer && board[2][2] == currentPlayer ||
           board[2][0] == currentPlayer && board[1][1] == currentPlayer && board[0][2] == currentPlayer {
            currentPlayer == "X" ? (scoreX += 1) : (scoreO += 1)
            message = "\(currentPlayer) Wins!"
            presentEndOfGameAlert()
            return
        }
        
        if !board.joined().contains("") {
            message = "Draw"
            presentEndOfGameAlert()
        }
    }
}
