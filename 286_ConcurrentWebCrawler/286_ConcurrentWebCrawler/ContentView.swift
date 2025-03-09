import SwiftUI

struct ContentView: View {

    @State private var items: [URL: Page] = [:]
    @State private var loading = false

    var body: some View {
        List {
            ForEach(Array(items.keys.sorted(by: { $0.absoluteString < $1.absoluteString })), id: \.self) { url in
                HStack {
                    Text(url.absoluteString)
                    Text(items[url]!.title)
                }

            }
        }
        .overlay(
            Text("\(items.count) items")
                .padding()
                .background(Color.black.opacity(0.8))

        )
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            do {
                let results = crawl(url: URL(string: "https://talk.objc.io/")!)
                for try await page in results {
                    items[page.url] = page
                }
            } catch {
                print(error)
            }
        }
    }
}
