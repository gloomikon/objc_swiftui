import SwiftUI

prefix func -(size: CGSize) -> CGSize {
    CGSize(width: -size.width, height: -size.height)
}
