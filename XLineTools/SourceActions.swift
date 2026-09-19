//
//  SourceActions.swift
//  XLineTool
//

import Foundation

class ActionBase {
    let buffer: any SourceTextBuffer
    let selectedLines: SourceTextRange
    let endLine: Int

    init(on buffer: any SourceTextBuffer) throws(ActionError) {
        self.buffer = buffer
        guard let selectedLines = buffer.selection else {
            throw ActionError.noSelection
        }

        self.selectedLines = selectedLines
        let rejectFinal = selectedLines.start.line != selectedLines.end.line
            && selectedLines.end.column == 0
        endLine = rejectFinal ? selectedLines.end.line - 1 : selectedLines.end.line
    }
}

class DuplicateLineAction: ActionBase {
    func run() {
        var duplicated = [String]()
        for index in selectedLines.start.line ... endLine {
            if let line = buffer.line(at: index) {
                duplicated.append(line)
            }
        }

        for (index, line) in duplicated.enumerated() {
            let insertionIndex = endLine + 1 + index
            if insertionIndex < buffer.lineCount {
                buffer.insert(line: line, at: insertionIndex)
            } else {
                buffer.append(line: line)
            }
        }
    }
}

class NewlineAction: ActionBase {
    func run() {
        let insertionIndex = endLine + 1
        var column = 0

        if insertionIndex < buffer.lineCount,
           let selectedLine = buffer.line(at: selectedLines.end.line) {
            let indentation = selectedLine.prefix {
                guard let scalar = $0.unicodeScalars.first else {
                    return false
                }
                return CharacterSet.whitespaces.contains(scalar)
            }
            column = indentation.count
            buffer.insert(line: String(indentation), at: insertionIndex)
        } else {
            buffer.append(line: "")
        }

        let location = SourceTextPosition(line: insertionIndex, column: column)
        buffer.setSelection(SourceTextRange(start: location, end: location))
    }
}

enum ActionError: Error {
    case noSelection
    case unknownCommand(String)
}
