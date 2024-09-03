# Attributed String Builder

337 - We begin implementing an attributed string builder to replace the legacy infrastructure for rendering our books - [Video](https://talk.objc.io/episodes/S01E337-attributed-string-builder-part-1)  
338 - We refactor the attributed string builder to support joining with a configurable separator - [Video](https://talk.objc.io/episodes/S01E338-attributed-string-builder-part-2)  
339 - We add modifiers to apply various kinds of attributes and integrate Swift syntax highlighting - [Video](https://talk.objc.io/episodes/S01E339-attributed-string-builder-part-3)  
340 - We add support for images and SwiftUI embeds to our attributed string builder - [Video](https://talk.objc.io/episodes/S01E340-attributed-string-builder-part-4)   
341 - We add support for Markdown and make it styleable using a custom stylesheet - [Video](https://talk.objc.io/episodes/S01E341-attributed-string-builder-part-5)  
342 - To conclude this series, we render the result of our attributed string builder to a PDF file - [Video](https://talk.objc.io/episodes/S01E342-attributed-string-builder-part-6)  


## Result
```swift
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
```

Converts to [PDF](https://github.com/gloomikon/objc_swiftui/blob/main/337_AttributedStringBuilder/assets/out.pdf)
