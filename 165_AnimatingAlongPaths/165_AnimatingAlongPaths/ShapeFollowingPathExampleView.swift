import SwiftUI

struct ShapeFollowingPathExampleView: View {

    @State private var position: CGFloat = .zero

    var body: some View {
        VStack {
            ZStack {
                Eight()
                    .stroke(Color.gray)
                OnPath(
                    shape: ArrowHead().size(width: 30, height: 30),
                    pathShape: Eight(),
                    offset: position
                )
                .onAppear {
                    withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                        position = 1
                    }
                }
                .foregroundStyle(Color.black)
            }
            .aspectRatio(16 / 9, contentMode: .fit)
            .padding(20)
        }
    }
}
