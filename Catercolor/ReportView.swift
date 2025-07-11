//
//  ReportView.swift
//  Catercolor
//
//  Created by Jennifer Warbeck on 11.07.25.
//

import SwiftUICore

struct ReportView: View {
    let childName: String
    let childAge: String
    let date: String
    let gameResults: GameResult
    let diagnosis: String
    let caterpillarStates: [Caterpillar]

    var body: some View {
        VStack(spacing: 20) {
            Text("Report").font(.largeTitle)
            Text("Name: \(childName)").bold()
            Text("Age: \(childAge)")
            Text("Date: \(date)")

            // Caterpillar snapshot section (simplified example)
            HStack {
                ForEach(caterpillarStates) { caterpillar in
                    VStack {
                        Image("\(caterpillar.color.rawValue)")
                            .resizable()
                            .frame(width: 50, height: 50)
                        ForEach(caterpillar.segments) { segment in
                            Circle()
                                .fill(segment.color)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }

            // Results
            VStack(alignment: .leading) {
                Text("Results").font(.headline)
                Text("Red mistakes: \(gameResults.incorrectMatches[.red, default: 0])")
                Text("Green mistakes: \(gameResults.incorrectMatches[.green, default: 0])")
                Text("Blue mistakes: \(gameResults.incorrectMatches[.blue, default: 0])")
                Text("Yellow mistakes: \(gameResults.incorrectMatches[.yellow, default: 0])")
            }

            Text(diagnosis)
                .font(.title3)
                .padding()

            Text("Disclaimer: This test is not a substitute for medical examination. Consult a doctor if you have doubts.")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}
