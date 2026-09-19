//
//  SourceEditorCommand.swift
//  XLineTool
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    func perform(
        with invocation: XCSourceEditorCommandInvocation,
        completionHandler: @escaping (Error?) -> Void) {
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

private extension ActionError {
    var cocoa: NSError {
        switch self {
        case .noSelection:
            NSError(domain: "No Selection", code: 1)
        case let .unknownCommand(name):
            NSError(domain: "Unknown command: \(name)", code: 1)
        }
    }
}
