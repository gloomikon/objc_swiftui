import SwiftUI

let urls = [
    URL(string: "https://www.objc.io/index.html")!,
    URL(string: "https://mirror.accum.se/mirror/wikimedia.org/dumps/enwiki/20250301/enwiki-20250301-pages-logging1.xml.gz")!
]

struct DownloadView: View {
    @ObservedObject var model: DownloadModel

    var body: some View {
        VStack {
            Text("\(model.url)")
                .frame(maxWidth: .infinity, alignment: .leading)

            if let progress = model.progress, progress.bytesExpected > 0 {
                ProgressView("Progress", value: Double(progress.bytesWritten), total: Double(progress.bytesExpected))
                    .progressViewStyle(.linear)
            }

            switch model.state {
            case .notStarted:
                Button("Start") {
                    Task { [model] in
                        await model.start()
                    }
                }
            case .started:
                HStack {
                    if model.progress == nil {
                        ProgressView()
                            .progressViewStyle(.linear)
                    }

                    Button("Pause") {
                        Task { [model] in
                            await model.pause()
                        }
                    }
                }
            case .paused(resumeData: _):
                Text("Paused...")
                Button("Resume") {
                    Task {
                        await model.start()
                    }
                }
            case let .done(url):
                Text("Done: \(url)")
            }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            ForEach(urls, id: \.self) { url in
                DownloadView(model: DownloadModel(url))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
