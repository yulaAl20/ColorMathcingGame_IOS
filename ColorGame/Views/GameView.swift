//
//  HomeView.swift
//  ColorGame
//
//  Created by cobsccomp242p-066 on 2026-01-12.

import SwiftUI

struct GameView: View {
    @StateObject private var engine: GameEngine
    @State private var positions: [UUID: CGPoint] = [:]
    @Environment(\.dismiss) private var dismiss

    init(difficulty: Difficulty) {
        _engine = StateObject(wrappedValue: GameEngine(difficulty: difficulty))
    }

    var body: some View {
        VStack {
            header

            ZStack {
                // 🔗 Connection line
                Canvas { context, _ in
                    var path = Path()
                    for (index, tile) in engine.selectedTiles.enumerated() {
                        guard let point = positions[tile.id] else { continue }
                        index == 0 ? path.move(to: point) : path.addLine(to: point)
                    }
                    context.stroke(path, with: .color(.white), lineWidth: 4)
                }

                // 🟦 Grid
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible(), spacing: 4),
                        count: engine.size
                    ),
                    spacing: 4
                ) {
                    ForEach(engine.grid.flatMap { $0 }) { tile in
                        TileView(
                            tile: tile,
                            isSelected: engine.selectedTiles.contains(tile)
                        )
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: TilePositionKey.self,
                                    value: [
                                        tile.id:
                                            geo.frame(in: .named("grid"))
                                               .centerPoint
                                    ]
                                )
                            }
                        )
                        .onTapGesture {
                            engine.select(tile: tile)

                        }

                    }
                }
                .coordinateSpace(name: "grid")
                .onPreferenceChange(TilePositionKey.self) {
                    positions = $0
                }
            }
            .padding()
            
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text("Score: \(engine.score)")
                .font(.headline)

            Spacer()

            if let time = engine.remainingTime {
                Text("⏱ \(time)s")
            }
        }
        .foregroundColor(.white)
        .padding()
    }
}
