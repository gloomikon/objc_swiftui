//
//  ContentView.swift
//  165_AnimatingAlongPaths
//
//  Created by Admin on 04.05.2024.
//

import SwiftUI


struct OnPath<P: Shape, S: Shape>: Shape {
    var shape: S
    let pathShape: P
    var offset: CGFloat // 0...1

    func path(in rect: CGRect) -> Path {
        let path = pathShape.path(in: rect)
        let point = path.point(at: offset)
        let shapePath = shape.path(in: rect)
        let size = shapePath.boundingRect.size
        let head = shapePath.offsetBy(
            dx: point.x - size.width / 2,
            dy: point.y - size.height / 2
        )

        var result = Path()
        let trailLength = 0.2 as CGFloat

        let trimFrom = offset - trailLength
        if trimFrom < .zero {
            result.addPath(
                path
                    .trimmedPath(from: trimFrom + 1, to: 1)
                    .strokedPath(.init())
            )
        }

        result.addPath(
            path
                .trimmedPath(from: max(0, trimFrom), to: offset)
                .strokedPath(.init())
        )

        result.addPath(head)
        return result
    }

    var animatableData: AnimatablePair<CGFloat, S.AnimatableData> {
        get {
            AnimatablePair(offset, shape.animatableData)
        }
        set {
            offset = newValue.first
            shape.animatableData = newValue.second
        }
    }

}

extension Path {
    func point(at position: CGFloat) -> CGPoint {
        assert(position >= 0 && position <= 1)
        guard position > 0 else { 
            return cgPath.currentPoint
        }

        return trimmedPath(
            from: 0,
            to: position
        )
        .cgPath
        .currentPoint
    }
}
struct ContentView: View {

    var rect: some Shape {
        Rectangle().size(width: 30, height: 30)
    }

    @State private var position: CGFloat = .zero

    var body: some View {
        VStack {
            ZStack {
                Eight()
                    .stroke(Color.gray)
                OnPath(
                    shape: rect,
                    pathShape: Eight(),
                    offset: position
                )
                .onAppear {
                    position = 1
                }
                .foregroundStyle(Color.black)
                .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false), value: position)

            }
            .aspectRatio(16 / 9, contentMode: .fit)
            .padding(20)
        }
    }
}

#Preview {
    ContentView()
}
