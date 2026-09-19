import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        switch invocation.commandIdentifier {
        case "dev.p3l6.XLineTool.XLineTools.Duplicate":
            do {
                let action = try DuplicateLineAction(on: invocation.buffer)
                action.run()
                completionHandler(nil)
            } catch {
                completionHandler(error.cocoa)
            }
        case "dev.p3l6.XLineTool.XLineTools.NewlineAfter":
            do {
                let action = try NewlineAction(on: invocation.buffer)
                action.run()
                completionHandler(nil)
            } catch {
                completionHandler(error.cocoa)
            }
        default:
            completionHandler(ActionError.unknownCommand(invocation.commandIdentifier).cocoa)
        }
    }
}

class ActionBase {
    let buffer: XCSourceTextBuffer
    let selectedLines: XCSourceTextRange
    let endLine: Int

    init(on buffer: XCSourceTextBuffer) throws(ActionError) {
        self.buffer = buffer
        guard let selectedLines = buffer.selections.firstObject as? XCSourceTextRange else {
            throw ActionError.noSelection
        }
        self.selectedLines = selectedLines
        let rejectFinal = selectedLines.start.line != selectedLines.end.line && selectedLines.end.column == 0
        endLine = rejectFinal ? selectedLines.end.line - 1 : selectedLines.end.line
    }
}

// MARK: Action handlers

class DuplicateLineAction: ActionBase {
    func run() {
        var duplicated = [String]()
        for index in selectedLines.start.line...endLine {
            if index < buffer.lines.count {
                duplicated.append(buffer.lines[index] as! String)
            }
        }
        for (index, line) in duplicated.enumerated() {
            let at = endLine + 1 + index
            if at < buffer.lines.count {
                buffer.lines.insert(line, at: at)
            } else {
                buffer.lines.add(line)
            }
        }
    }
}

class NewlineAction: ActionBase {
    func run() {
        let at = endLine + 1
        var column = 0
        if at < buffer.lines.count {
            let line = (buffer.lines[selectedLines.end.line] as! String).prefix { (char: Character) -> Bool in
                return CharacterSet.whitespaces.contains(char.unicodeScalars.first!)
            }
            column = line.count
            buffer.lines.insert(line, at: at)
        } else {
            buffer.lines.add("")
        }
        let location = XCSourceTextPosition(line: at, column: column)
        buffer.selections.removeAllObjects()
        buffer.selections.add(XCSourceTextRange(start: location, end: location))
    }
}


// MARK: Errors

enum ActionError: Error {
    case noSelection
    case unknownCommand(String)

    var cocoa: NSError {
        switch self {
        case .noSelection: NSError(domain: "No Selection", code: 1, userInfo: nil)
        case let .unknownCommand(name): NSError(domain:"Unknown command: \(name)", code: 1, userInfo: nil)
        }
    }
}
