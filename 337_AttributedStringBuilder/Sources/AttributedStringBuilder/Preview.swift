#if DEBUG
import SwiftUI

@AttributedStringBuilder
var example: some AttributedStringConvertible {
    "Hello, World!"
        .bold()
    "Another String"

    NSImage(systemSymbolName: "hand.wave", accessibilityDescription: nil)!

    #"""
    static var previews: some View {
        let attStr = example
            .joined()
            .run(environment: .init(attributes: sampleAttributes))
        Text(AttributedString(attStr))
    }
    """#
        .highlightSwift()

    HStack {
        Image(systemName: "hand.wave")
        Text("Hello from SwiftUI")
    }
    .border(.red)
    .embed(proposal: .init(width: 100, height: nil))

    """
    This some markdown with **strong** text.

    Another *paragraph*
    """
        .markdown()
}

let attributes = Attributes(size: 20)

@MainActor let string = example.joined().run(environment: Environment(attributes: attributes))

struct TextView: NSViewRepresentable {

    let attributedString: NSAttributedString

    init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    func makeNSView(context: Context) -> NSTextView {
        let view = NSTextView()
        view.isEditable = false
        view.textContainer?.lineFragmentPadding = 0
        view.textContainer?.widthTracksTextView = false
        view.drawsBackground = true
        view.backgroundColor = .white
        return view
    }

    func updateNSView(_ view: NSViewType, context: Context) {
        view.textStorage?.setAttributedString(attributedString)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, nsView: NSTextView, context: Context) -> CGSize? {
        let size = proposal.replacingUnspecifiedDimensions(by: .zero)
        nsView.textContainer?.size = size
        if let container = nsView.textContainer {
            nsView.layoutManager?.ensureLayout(for: container)
        }
        return nsView.textContainer.flatMap { container in
            nsView.layoutManager?.usedRect(for: container).size
        }
    }
}

#Preview {
//    Text(AttributedString(string))
    TextView(string)
        .padding()
        .previewLayout(.sizeThatFits)
}


#endif

