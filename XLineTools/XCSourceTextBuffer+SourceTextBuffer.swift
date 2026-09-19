//
//  XCSourceTextBuffer+SourceTextBuffer.swift
//  XLineTool
//

import XcodeKit

extension XCSourceTextBuffer: SourceTextBuffer {
    var lineCount: Int {
        lines.count
    }

    var selection: SourceTextRange? {
        guard let selection = selections.firstObject as? XCSourceTextRange else {
            return nil
        }

        return SourceTextRange(
            start: SourceTextPosition(
                line: selection.start.line,
                column: selection.start.column),
            end: SourceTextPosition(
                line: selection.end.line,
                column: selection.end.column))
    }

    func line(at index: Int) -> String? {
        lines[index] as? String
    }

    func replaceLine(at index: Int, with line: String) {
        lines[index] = line
    }

    func removeLine(at index: Int) {
        lines.removeObject(at: index)
    }

    func insert(line: String, at index: Int) {
        lines.insert(line, at: index)
    }

    func append(line: String) {
        lines.add(line)
    }

    func setSelection(_ selection: SourceTextRange) {
        let start = XCSourceTextPosition(
            line: selection.start.line,
            column: selection.start.column)
        let end = XCSourceTextPosition(
            line: selection.end.line,
            column: selection.end.column)

        selections.removeAllObjects()
        selections.add(XCSourceTextRange(start: start, end: end))
    }
}
