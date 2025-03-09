import SwiftUI

struct ContentView: View {

    @StateObject var crawler = Crawler()
    @State var loading = false

    var body: some View {
        List {
            ForEach(Array(crawler.state.keys.sorted(by: { $0.absoluteString < $1.absoluteString })), id: \.self) { url in
                HStack {
                    Text(url.absoluteString)
                    Text(crawler.state[url]!.title)
                }

            }
        }
        .overlay(
            Text("\(crawler.state.count) items")
                .padding()
                .background(Color.black.opacity(0.8))

        )
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task { [crawler] in
            do {
                try await crawler.crawl(url: URL(string: "https://talk.objc.io/")!)
            } catch {
                print(error)
            }
        }
    }
}
