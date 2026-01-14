//
//  GameView.swift
//  ColorGame
//
//  Created by cobsccomp242p-066 on 2026-01-12.
//
import SwiftUI

struct GameView: View {
    @StateObject private var engine: GameEngine
    @Environment(\.dismiss) private var dismiss

    init(difficulty: Difficulty) {
        _engine = StateObject(wrappedValue: GameEngine(difficulty: difficulty))
    }

    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()

            VStack {
                header
                gameArea
            }

            if engine.isInvalidSelection {
                Text("Tiles must be the same color!")
                    .padding()
                    .background(Color.red.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            if engine.lastScoreGained > 0 {
                Text("+\(engine.lastScoreGained)")
                    .font(.title.bold())
                    .foregroundColor(.green)
                    .offset(y: -120)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            engine.lastScoreGained = 0
                        }
                    }
            }
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
                .font(.title3.bold())

            Spacer()

            Button { engine.setupGrid() } label: {
                Image(systemName: "arrow.clockwise")
            }
        }
        .foregroundColor(.white)
        .padding()
    }

    private var gameArea: some View {
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: 4),
            count: engine.size
        )

        return ZStack {
            Canvas { context, size in
                guard engine.selectedTiles.count > 1 else { return }

                var path = Path()
                let tileSize = size.width / CGFloat(engine.size)

                for (i, tile) in engine.selectedTiles.enumerated() {
                    let x = CGFloat(tile.col) * tileSize + tileSize / 2
                    let y = CGFloat(tile.row) * tileSize + tileSize / 2

                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }

                context.stroke(path, with: .color(.white), lineWidth: 4)
            }

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(engine.grid.flatMap { $0 }) { tile in
                    TileView(
                        tile: tile,
                        isSelected: engine.selectedTiles.contains(tile)
                    )
                    .onTapGesture {
                        engine.select(tile: tile)
                    }
                }
            }
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            engine.completeMatch()
        }
    }
}

struct TileView: View {
    let tile: Tile
    let isSelected: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(tile.color.color.gradient)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: isSelected ? 3 : 1)
            }
    }
}
