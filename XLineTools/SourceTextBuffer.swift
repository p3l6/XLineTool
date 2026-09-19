//
//  SourceTextBuffer.swift
//  XLineTool
//

import Foundation

struct SourceTextPosition: Equatable {
    let line: Int
    let column: Int
}

struct SourceTextRange: Equatable {
    let start: SourceTextPosition
    let end: SourceTextPosition
}

protocol SourceTextBuffer {
    var lineCount: Int { get }
    var selection: SourceTextRange? { get }

    func line(at index: Int) -> String?
    func replaceLine(at index: Int, with line: String)
    func insert(line: String, at index: Int)
    func append(line: String)
    func setSelection(_ selection: SourceTextRange)
}
