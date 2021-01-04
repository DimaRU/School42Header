//
//  ViewController.swift
//  School42Header
//
//  Created by Dmitriy Borovikov on 04.01.2021.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var userNameField: NSTextField!
    @IBOutlet weak var emailField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameField.stringValue = Preferences.username ?? ""
        emailField.stringValue = Preferences.email ?? ""
    }

    override func viewDidDisappear() {
        savePreferences()
    }

    private func savePreferences() {
        Preferences.username = userNameField.stringValue.isEmpty ? nil : userNameField.stringValue
        Preferences.email = emailField.stringValue.isEmpty ? nil : emailField.stringValue
    }
}

extension ViewController: NSTextFieldDelegate {
    func controlTextDidEndEditing(_ obj: Notification) {
        savePreferences()

    }
}
