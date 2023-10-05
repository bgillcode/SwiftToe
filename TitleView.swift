import SwiftUI
import Combine

struct FloatingTile: View {
    let symbol: String
    @State private var randomXOffset: CGFloat = CGFloat.random(in: -50...50)
    @State private var randomYOffset: CGFloat = CGFloat.random(in: -50...50)
    
    var body: some View {
        Text(symbol)
            .font(.largeTitle)
            .opacity(0.3)
            .offset(x: randomXOffset, y: randomYOffset)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    randomXOffset = CGFloat.random(in: -150...150)
                    randomYOffset = CGFloat.random(in: -150...150)
                }
            }
    }
}

struct TitleView: View {
    @ObservedObject var audioManager = AudioManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                // Floating Tiles
                ForEach(0..<5) { _ in
                    FloatingTile(symbol: Bool.random() ? "X" : "O")
                }
                
                // VStack for the title and the start game button
                VStack(spacing: 20) {
                    Text("SwiftToe")
                        .font(.largeTitle)
                        .bold()

                    NavigationLink(destination: ContentView()) {
                        Text("Start New Game")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    HStack {
                        Link(destination: URL(string: "https://www.github.com/bgillcode")!, label: {
                            Text("By: bgillcode")
                            Image("github-icon")
                                .resizable()
                                .frame(width: 20, height: 20)
                        })
                            .font(.caption)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarItems(trailing:
                Button(action: {
                    audioManager.toggleMute()
                }) {
                    Image(systemName: audioManager.isMuted ? "speaker.slash.fill" : "speaker.fill")
                        .frame(width: 24, height: 24)
                        .padding()
                        .animation(.none)
                }
            )
        }
    }
}
