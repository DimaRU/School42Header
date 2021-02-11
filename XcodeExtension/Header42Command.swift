//
//  Header42Command.swift
//  XcodeExtension
//
//  Created by Dmitriy Borovikov on 04.01.2021.
//

import Foundation
import XcodeKit

class Header42Command: NSObject, XCSourceEditorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {

        guard
            let username = Preferences.username,
            let email = Preferences.email
        else {
            let error = NSError(domain: "",
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "No Username or Email settings"])
            completionHandler(error)
            return
        }

        let lines = invocation.buffer.lines

        if header42.isHeader42(in: lines) {
            header42.updateHeader42(username: username, in: lines)
            completionHandler(nil)
        } else if header42.isHeaderXcode(in: lines) {
            let filename = header42.getFilename(from: lines)
            header42.removeHeaderXcode(in: lines)
            header42.insertHeader42(filename: filename, username: username, email: email, in: lines)
            completionHandler(nil)
        } else {
            header42.insertHeader42(filename: "@filename.c@", username: username, email: email, in: lines)
            completionHandler(nil)
        }
    }
}
