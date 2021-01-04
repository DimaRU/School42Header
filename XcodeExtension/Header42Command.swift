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
        
        completionHandler(nil)
    }
    
}
