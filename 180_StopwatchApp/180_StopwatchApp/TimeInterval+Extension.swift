import Foundation

private let dateFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.zeroFormattingBehavior = .pad
    return formatter
}()

private let numbersFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.minimumIntegerDigits = 0
    formatter.alwaysShowsDecimalSeparator = true
    return formatter
}()

extension TimeInterval {

    var formatted: String {
        let ms = self.truncatingRemainder(dividingBy: 1)
        return dateFormatter.string(from: self)! + numbersFormatter.string(from: NSNumber(value: ms))!
    }
}
