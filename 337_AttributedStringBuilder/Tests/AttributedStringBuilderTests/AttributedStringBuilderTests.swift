import XCTest
@testable import AttributedStringBuilder

import SwiftUI

final class AttributedStringBuilderTests: XCTestCase {

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

    @MainActor var string: NSAttributedString {
        example.joined().run(environment: Environment(attributes: attributes))
    }

    @MainActor
    func testExample() throws {
        let data = string.pdf()
        try! data.write(to: .desktopDirectory.appending(component: "out.pdf"))
    }
}
