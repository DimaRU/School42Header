//
//  Preferences.swift
//  XcodeExtension
//
//  Created by Dmitriy Borovikov on 04.01.2021.
//

import Foundation

struct Preferences {
    @UserPreference("username")
    static var username: String?

    @UserPreference("email")
    static var email: String?
}
