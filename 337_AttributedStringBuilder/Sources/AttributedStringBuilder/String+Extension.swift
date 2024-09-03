import Cocoa
import SwiftHighlighting

extension String {
    func highlightSwift() -> NSAttributedString {
        .highlightSwift(self, stylesheet: .xcodeDefault)
    }
}
