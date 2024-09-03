import Cocoa
import SwiftUI

private struct Embed<Content: View>: AttributedStringConvertible {

    var proposal: ProposedViewSize = .unspecified
    @ViewBuilder var content: Content

    @MainActor
    func attributedString(environment: Environment) -> [NSAttributedString] {
        let renderer = ImageRenderer(content: content)
        renderer.proposedSize = proposal
        let resultingSize = renderer.nsImage?.size ?? .zero
        let data = NSMutableData()

        renderer.render { size, renderer in
            var mediaBox = CGRect(origin: .zero, size: resultingSize)

            guard let consumer = CGDataConsumer(data: data),
                  let pdfContext =  CGContext(consumer: consumer, mediaBox: &mediaBox, nil)
            else {
                return
            }
            pdfContext.beginPDFPage(nil)
            pdfContext.translateBy(x: mediaBox.size.width / 2 - size.width / 2,
                                   y: mediaBox.size.height / 2 - size.height / 2)
            renderer(pdfContext)
            pdfContext.endPDFPage()
            pdfContext.closePDF()
        }

        return NSImage(data: data as Data)?.attributedString(environment: environment) ?? []
    }

}

extension View {

    func embed(proposal: ProposedViewSize = .unspecified) -> some AttributedStringConvertible {
        Embed(proposal: proposal) {
            self
        }
    }
}
