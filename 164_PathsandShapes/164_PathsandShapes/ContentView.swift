import SwiftUI

struct Badge: View {
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height
                )
                .foregroundStyle(Color.orange)
                .rotationEffect(Angle(degrees: 45), anchor: .center)
                .offset(x: -proxy.size.width / 2, y: -proxy.size.height / 2)

        }
    }
}

struct RectBadge: View {
    var body: some View {
        GeometryReader { proxy in
            Path { path in
                path.move(to: .zero)
                path.addLine(to: CGPoint(x: proxy.size.width, y: .zero))
                path.addLine(to: CGPoint(x: .zero, y: proxy.size.height))
                path.closeSubpath()
            }
            .foregroundStyle(Color.orange)
        }
    }
}

struct Rectangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: rect.origin)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.origin.y))
            path.addLine(to: CGPoint(x: rect.origin.x, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

struct RectBadge2: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color.orange)
            Text("Preview")
                .font(.headline)
                .foregroundStyle(Color.white)
                .padding(.bottom, 30)
                .rotationEffect(Angle(degrees: -45))
        }
    }
}

struct ContentView: View {

    @State private var size: CGFloat = 100

    var body: some View {
        VStack {

            ZStack(alignment: .topLeading) {
                Image("ed-under-moon")
                    .resizable()
                    .scaledToFit()

                RectBadge2()
                    .frame(width: size, height: size)
            }

            Slider(value: $size, in: 100...200)
        }
    }
}

#Preview {
    ContentView()
}
