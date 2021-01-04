//
//  Header42Command.swift
//  XcodeExtension
//
//  Created by Dmitriy Borovikov on 04.01.2021.
//

import Foundation
import XcodeKit

class Header42Command: NSObject, XCSourceEditorCommand {

    enum Header42Error: Error, LocalizedError {
        case hoHeader

        var errorDescription: String {
            switch self {
            case .hoHeader: return "No school 42 ether Xcode header. Please replace filename.c"
            }
        }
    }

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {

        let lines = invocation.buffer.lines

        if header42.isHeader42(in: lines) {
            header42.updateHeader42(in: lines)
            completionHandler(nil)
        } else if header42.isHeaderXcode(in: lines) {
            let filename = header42.getFilename(from: lines)
            header42.removeHeaderXcode(in: lines)
            header42.insertHeader42(filename: filename, username: "DimaRU", email: "dimaru@42.fr", in: lines)
            completionHandler(nil)
        } else {
            header42.insertHeader42(filename: "filename.c", username: "DimaRU", email: "dimaru@42.fr", in: lines)
            completionHandler(Header42Error.hoHeader)
        }
    }
}
