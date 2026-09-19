//
//  XLineToolsTests.swift
//  XLineTool
//

import Testing

struct XLineToolsTests {
    @Test func `Duplicate action copies the selected lines`() throws {
        let buffer = MockSourceTextBuffer(
            lines: ["first\n", "second\n", "third\n"],
            selection: range(fromLine: 0, column: 0, toLine: 2, column: 0))

        try DuplicateLineAction(on: buffer).run()

        #expect(buffer.lines == [
            "first\n",
            "second\n",
            "first\n",
            "second\n",
            "third\n"
        ])
    }

    @Test func `Newline action inserts an indented line and moves the selection`() throws {
        let buffer = MockSourceTextBuffer(
            lines: ["    value\n", "next\n"],
            selection: range(fromLine: 0, column: 5, toLine: 0, column: 5))

        try NewlineAction(on: buffer).run()

        #expect(buffer.lines == ["    value\n", "    ", "next\n"])
        #expect(buffer.selection == range(
            fromLine: 1,
            column: 4,
            toLine: 1,
            column: 4))
    }

    @Test func `Trim trailing whitespace processes every line`() {
        let buffer = MockSourceTextBuffer(
            lines: [
                "let value = 1   \n",
                "\t \t\n",
                "    leading and interior   spaces\t\r\n",
                "unchanged\n",
                "trailing tabs\t\t"
            ],
            selection: nil)

        TrimTrailingWhitespaceAction(on: buffer).run()

        #expect(buffer.lines == [
            "let value = 1\n",
            "\n",
            "    leading and interior   spaces\r\n",
            "unchanged\n",
            "trailing tabs"
        ])
    }

    private func range(
        fromLine startLine: Int,
        column startColumn: Int,
        toLine endLine: Int,
        column endColumn: Int) -> SourceTextRange {
        SourceTextRange(
            start: SourceTextPosition(line: startLine, column: startColumn),
            end: SourceTextPosition(line: endLine, column: endColumn))
    }
}
