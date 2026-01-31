import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        guard let selectedLines = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(NSError(domain: "No Selection", code: 1, userInfo: nil))
            return
        }

        let rejectFinal = selectedLines.start.line != selectedLines.end.line && selectedLines.end.column == 0
        let endLine = rejectFinal ? selectedLines.end.line - 1 : selectedLines.end.line

        switch invocation.commandIdentifier {
        case "dev.p3l6.XLineTool.XLineTools.Duplicate":
            var duplicated = [String]()
            for index in selectedLines.start.line...endLine {
                if index < invocation.buffer.lines.count {
                    duplicated.append(invocation.buffer.lines[index] as! String)
                }
            }
            for (index, line) in duplicated.enumerated() {
                let at = endLine + 1 + index
                if at < invocation.buffer.lines.count {
                    invocation.buffer.lines.insert(line, at: at)
                } else {
                    invocation.buffer.lines.add(line)
                }
            }
            completionHandler(nil)

        case "dev.p3l6.XLineTool.XLineTools.NewlineAfter":
            let at = endLine + 1
            var column = 0
            if at < invocation.buffer.lines.count {
                let line = (invocation.buffer.lines[selectedLines.end.line] as! String).prefix { (char: Character) -> Bool in
                    return CharacterSet.whitespaces.contains(char.unicodeScalars.first!)
                }
                column = line.count
                invocation.buffer.lines.insert(line, at: at)
            } else {
                invocation.buffer.lines.add("")
            }
            let location = XCSourceTextPosition(line: at, column: column)
            invocation.buffer.selections.removeAllObjects()
            invocation.buffer.selections.add(XCSourceTextRange(start: location, end: location))
            completionHandler(nil)
            
        default:
            completionHandler(NSError(domain:"Unknown command: \(invocation.commandIdentifier)", code: 1, userInfo: nil))
        }
    }
}
