import SwiftUI

struct ViewFollowingPathExampleView: View {

    @State private var position: CGFloat = .zero

    var body: some View {
        VStack {
            ZStack {
                Eight()
                    .stroke(Color.gray)

                ZStack(alignment: .topLeading) {
                    Image(systemName: "applelogo")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Rectangle().fill(.clear)
                }
                .offset(x: -15, y: -15)
                .modifier(FollowPath(pathShape: Eight(), offset: position))

                Trail(pathShape: Eight(), offset: position)
                    .foregroundStyle(Color.black)
            }
            .aspectRatio(16 / 9, contentMode: .fit)
            .padding(20)
            .onAppear {
                withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                    position = 1
                }
            }
        }
    }
}
