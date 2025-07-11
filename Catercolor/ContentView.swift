import SwiftUI

struct ContentView: View {
    @State private var timerCount: Int = 180
    @State private var currentBall = ColorBall(color: .red, correctCaterpillar: .red, sizeMultiplier: 1.0)
    @State private var gameResults = GameResult()
    @State private var isGameRunning = false
    @State private var showSummary = false
    @State private var showCaterpillarAnimation = false
    @State private var animationStates: [CaterpillarAnimationState] = CaterpillarColor.allCases.map { _ in
        CaterpillarAnimationState()
    }

    var todaysDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    @State private var caterpillarStates: [Caterpillar] = CaterpillarColor.allCases.map {
        Caterpillar(color: $0, segments: [])
    }

    @State private var colorQueue: [CaterpillarColor] = []

    @State private var childName: String = ""
    @State private var childAge: String = ""

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            if showCaterpillarAnimation {
                caterpillarAnimationView
            } else if showSummary {
                summaryScreen
            } else if isGameRunning {
                gameScreen
            } else {
                startScreen
            }
        }
        .onReceive(timer) { _ in
            if isGameRunning && !showCaterpillarAnimation {
                if timerCount > 0 {
                    timerCount -= 1
                } else {
                    endGame()
                }
            }
        }
    }


    // MARK: Start Screen
    var startScreen: some View {
        VStack(spacing: 20) {
            Text("Enter Name and Age")
                .font(.title)

            TextField("Name", text: $childName)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.white)
                .cornerRadius(12)
                .font(.title3)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))

            TextField("Age", text: $childAge)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.white)
                .cornerRadius(12)
                .font(.title3)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))

            Text("Today's Date: \(todaysDate)")
                .font(.subheadline)
                .padding(.top, 8)

            Button(action: { startGame() }) {
                Text("Start Game")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 10)
        }
    }

    // MARK: Game Screen
    var gameScreen: some View {
        VStack {
            HStack {
                Text("Name: \(childName) | Age: \(childAge) | Date: \(todaysDate)")
                    .font(.headline)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                Spacer()
                Text("Time Left: \(timerCount)s")
                    .font(.headline)
                    .padding(.trailing, 20)
                    .padding(.top, 10)
            }

            Spacer()

            Circle()
                .fill(currentBall.color)
                .frame(width: 60, height: 60)
                .onDrag {
                    NSItemProvider(object: "topBall:\(currentBall.correctCaterpillar.rawValue)" as NSString)
                }
                .padding()

            Spacer()

            HStack {
                ForEach($caterpillarStates, id: \.color) { $caterpillar in
                    Spacer()
                    VStack {
                        VStack(spacing: -10) {
                            Image("\(caterpillar.color.rawValue)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)

                            ForEach(caterpillar.segments.reversed()) { segment in
                                Circle()
                                    .fill(segment.color)
                                    .frame(width: 50 * segment.sizeMultiplier, height: 50 * segment.sizeMultiplier)
                                    .onDrag {
                                        NSItemProvider(object: "segment:\(segment.id.uuidString)" as NSString)
                                    }
                            }
                        }
                        .padding(30)
                        .contentShape(Rectangle())
                        .onDrop(of: [.plainText], isTargeted: nil) { providers in
                            handleDrop(providers: providers, to: caterpillar.color)
                        }
                    }
                    Spacer()
                }
            }
            .padding()
        }
    }

    // MARK: Caterpillar Animation View
    var caterpillarAnimationView: some View {
        HStack {
            Spacer()
            ForEach(caterpillarStates.indices, id: \.self) { i in
                let caterpillar = caterpillarStates[i]
                let animState = animationStates[i]

                VStack(spacing: -10) {
                    Image("\(caterpillar.color.rawValue)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)

                    ForEach(caterpillar.segments.reversed()) { segment in
                        Circle()
                            .fill(segment.color)
                            .frame(width: 50 * segment.sizeMultiplier, height: 50 * segment.sizeMultiplier)
                    }
                }
                .offset(x: animState.wiggleX,
                        y: animState.offsetY)
                .rotationEffect(.degrees(animState.rotation))
                .opacity(animState.opacity)
                .animation(.easeInOut(duration: 2.5), value: animState.offsetY)

                Spacer()
            }
        }
        .onAppear {
            for i in animationStates.indices {
                animationStates[i].offsetY = 0 // start at current position
                animationStates[i].rotation = 0
                animationStates[i].opacity = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in animationStates.indices {
                    animationStates[i].offsetY = -800 // move up offscreen (adjust if needed)
                    animationStates[i].rotation = Double.random(in: -20...20)
                    animationStates[i].opacity = 0
                }
            }

            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                for i in animationStates.indices {
                    animationStates[i].wiggleX = CGFloat.random(in: -10...10)
                }
            }
        }
    }


    // MARK: Summary Screen
    var summaryScreen: some View {
        VStack(spacing: 20) {
            Text("Well done!")
                .font(.system(size: 36, weight: .bold))
                .padding(.top, 40)
            
            Text("Name: \(childName) | Age: \(childAge) | Date: \(todaysDate)")
                .font(.system(size: 25))
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            VStack(spacing: 8) {
                Text("Correct: \(gameResults.correctMatches.values.reduce(0, +))")
                Text("Incorrect: \(gameResults.incorrectMatches.values.reduce(0, +))")
                
                Text("Red mistakes: \(gameResults.incorrectMatches[.red, default: 0])")
                Text("Green mistakes: \(gameResults.incorrectMatches[.green, default: 0])")
                Text("Blue mistakes: \(gameResults.incorrectMatches[.blue, default: 0])")
                Text("Yellow mistakes: \(gameResults.incorrectMatches[.yellow, default: 0])")
            }
            .font(.body)
            .padding(.bottom, 20)
            
            Text(diagnosisMessage())
                .font(.title3)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            
            Button(action: { resetGame() }) {
                Text("Play Again")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: 275, minHeight: 70)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.blue))
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 20)
            
            Button(action: {
                // TODO: Add Download Report logic here
            }) {
                Text("Download Report")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: 250, minHeight: 50)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.gray))
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 10)
        }
        .padding()
    }


    // MARK: Game Logic

    func randomShade(for caterpillar: CaterpillarColor) -> Color {
        switch caterpillar {
        case .red:
            return Color(hue: Double.random(in: 0.95...1.0), saturation: Double.random(in: 0.6...1.0), brightness: Double.random(in: 0.7...1.0))
        case .green:
            return Color(hue: Double.random(in: 0.25...0.4), saturation: Double.random(in: 0.6...1.0), brightness: Double.random(in: 0.7...1.0))
        case .blue:
            return Color(hue: Double.random(in: 0.5...0.65), saturation: Double.random(in: 0.6...1.0), brightness: Double.random(in: 0.7...1.0))
        case .yellow:
            return Color(hue: Double.random(in: 0.12...0.16), saturation: Double.random(in: 0.6...1.0), brightness: Double.random(in: 0.7...1.0))
        }
    }

    func startGame() {
        isGameRunning = true
        showSummary = false
        timerCount = 180
        gameResults = GameResult(totalBalls: 0, correctMatches: [:], incorrectMatches: [:])
        caterpillarStates = CaterpillarColor.allCases.map { Caterpillar(color: $0, segments: []) }
        refillColorQueue()
        spawnNewBall()
    }

    func refillColorQueue() {
        colorQueue = CaterpillarColor.allCases.shuffled()
    }

    func spawnNewBall() {
        if colorQueue.isEmpty {
            refillColorQueue()
        }
        let nextColor = colorQueue.removeFirst()
        let randomColor = randomShade(for: nextColor)
        let randomSize = CGFloat.random(in: 0.9...1.1)
        currentBall = ColorBall(color: randomColor, correctCaterpillar: nextColor, sizeMultiplier: randomSize)
    }

    func handleDrop(providers: [NSItemProvider], to targetCaterpillar: CaterpillarColor) -> Bool {
        for provider in providers {
            provider.loadItem(forTypeIdentifier: "public.plain-text", options: nil) { item, _ in
                if let data = item as? Data, let str = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        if str.starts(with: "topBall:") {
                            let colorStr = str.replacingOccurrences(of: "topBall:", with: "")
                            if let sourceCaterpillar = CaterpillarColor(rawValue: colorStr) {
                                processTopBallDrop(to: targetCaterpillar, from: sourceCaterpillar)
                            }
                        } else if str.starts(with: "segment:") {
                            let segmentID = str.replacingOccurrences(of: "segment:", with: "")
                            moveSegment(withId: segmentID, to: targetCaterpillar)
                        }
                    }
                }
            }
        }
        return true
    }

    func processTopBallDrop(to target: CaterpillarColor, from source: CaterpillarColor) {
        if let index = caterpillarStates.firstIndex(where: { $0.color == target }) {
            let newSegment = CaterpillarSegment(color: currentBall.color, sizeMultiplier: currentBall.sizeMultiplier)
            caterpillarStates[index].segments.append(newSegment)
        }

        gameResults.totalBalls += 1

        if target == source {
            gameResults.correctMatches[target, default: 0] += 1
        } else {
            gameResults.incorrectMatches[target, default: 0] += 1
        }

        if checkCaterpillarsFull() {
            endGame()
        } else {
            spawnNewBall()
        }
    }

    func moveSegment(withId id: String, to target: CaterpillarColor) {
        guard let uuid = UUID(uuidString: id) else { return }

        for i in caterpillarStates.indices {
            if let segmentIndex = caterpillarStates[i].segments.firstIndex(where: { $0.id == uuid }) {
                let segment = caterpillarStates[i].segments.remove(at: segmentIndex)
                if let targetIndex = caterpillarStates.firstIndex(where: { $0.color == target }) {
                    caterpillarStates[targetIndex].segments.append(segment)
                }
                break
            }
        }
    }

    func checkCaterpillarsFull() -> Bool {
        return caterpillarStates.allSatisfy { $0.segments.count >= 10 }
    }

    func endGame() {
        isGameRunning = false
        showCaterpillarAnimation = true

        // After 3 seconds, show the summary screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showCaterpillarAnimation = false
                showSummary = true
            }
        }
    }


    func resetGame() {
        childName = ""
        childAge = ""
        showSummary = false
    }

    func diagnosisMessage() -> String {
        let redMistakes = gameResults.incorrectMatches[.red, default: 0]
        let greenMistakes = gameResults.incorrectMatches[.green, default: 0]
        let blueMistakes = gameResults.incorrectMatches[.blue, default: 0]
        let yellowMistakes = gameResults.incorrectMatches[.yellow, default: 0]
        let total = gameResults.totalBalls
        let totalIncorrect = gameResults.incorrectMatches.values.reduce(0, +)

        if redMistakes >= 3 || greenMistakes >= 3 {
            return "⚠️ Possible red-green color vision deficiency — recommend follow-up."
        } else if blueMistakes >= 3 || yellowMistakes >= 3 {
            return "⚠️ Possible blue-yellow color vision deficiency — recommend follow-up."
        } else if total > 0 && Double(totalIncorrect) / Double(total) > 0.3 {
            return "⚠️ High error rate — recommend vision screening."
        } else {
            return "✅ Likely normal color vision."
        }
    }
}
