final class MockSourceTextBuffer: SourceTextBuffer {
    private(set) var lines: [String]
    private(set) var selection: SourceTextRange?

    var lineCount: Int {
        lines.count
    }

    init(lines: [String], selection: SourceTextRange?) {
        self.lines = lines
        self.selection = selection
    }

    func line(at index: Int) -> String? {
        guard lines.indices.contains(index) else {
            return nil
        }
        return lines[index]
    }

    func insert(line: String, at index: Int) {
        lines.insert(line, at: index)
    }

    func append(line: String) {
        lines.append(line)
    }

    func setSelection(_ selection: SourceTextRange) {
        self.selection = selection
    }
}
