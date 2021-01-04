//
//  Header42.swift
//  XcodeExtension
//
//  Created by Dmitriy Borovikov on 04.01.2021.
//

import Foundation

struct Header42 {
let header42Template = """
/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   @filename                                 @        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: @username                             @    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: @created                           @     #+#    #+#             */
/*   Updated: @updated                           @    ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
""".split(separator: "\n").map{ String($0)}

    private func getDateLine(with username: String) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy/MM/dd hh:mm:ss"
        let dateString = formater.string(from: Date())
        let updateLine = "\(dateString) by \(username)"
        return updateLine
    }

    func isHeaderXcode(in lines: NSMutableArray) -> Bool {
        guard lines.count >= 6 else {
            return false
        }

        for index in 0..<6 {
            if !((lines[index] as? String) ?? "").hasPrefix("//") {
                return false
            }
        }
        return (lines[4] as! String).hasPrefix("//  Created by")
    }

    func getFilename(from lines: NSMutableArray) -> String {
        let line = lines[1] as! String
        return line.replacingOccurrences(of: "//  ", with: "").trimmingCharacters(in: .whitespaces)
    }

    func removeHeaderXcode(in lines: NSMutableArray) {
        let range = NSMakeRange(0, 6)
        lines.removeObjects(in: range)
    }

    func isHeader42(lines: NSMutableArray) -> Bool {
        guard lines.count >= 6 else {
            return false
        }

        for index in 0..<header42Template.count {
            let templateLine = header42Template[index]
            guard let line = lines[index] as? String else {
                return false
            }
            if let startPosition = templateLine.firstIndex(of: "@"),
               let endPosition = templateLine.lastIndex(of: "@") {
                let range = startPosition...endPosition
                let cleanedLine = line.replacingCharacters(in: range, with: templateLine[range])
                if templateLine != cleanedLine {
                    return false
                }
            } else {
                if templateLine != line {
                    return false
                }
            }
        }
        return true
    }

    func updateHeader42(username: String, in lines: NSMutableArray) {
        let index = header42Template.firstIndex(where: { $0.contains("@updated") })!
        var templateLine = header42Template[index]
        let startPosition = templateLine.firstIndex(of: "@")!
        let endPosition = templateLine.lastIndex(of: "@")!
        let replaceLen = templateLine.distance(from: startPosition, to: endPosition) + 1
        let updateLine = getDateLine(with: username).padding(toLength: replaceLen, withPad: " ", startingAt: 0)
        templateLine.replaceSubrange(startPosition...endPosition, with: updateLine)
        lines[index] = templateLine
    }

    func createHeader42(filename: String, username: String, email: String, in lines: NSMutableArray) {
        var header: [String] = []
        let timeLine = getDateLine(with: username)

        for templateLine in header42Template {
            guard
                let startPosition = templateLine.firstIndex(of: "@"),
                let endPosition = templateLine.lastIndex(of: "@")
            else {
                header.append(templateLine)
                continue
            }
            let range = startPosition...endPosition
            let replaceLen = templateLine.distance(from: startPosition, to: endPosition) + 1

            let id = templateLine[range].trimmingCharacters(in: [" ", "@"])
            let replaceLine: String
            switch id {
            case "filename":
                replaceLine = filename
            case "username":
                replaceLine = "\(username) <\(email)>"
            case "created",
                 "updated":
                replaceLine = timeLine
            default:
                print("Illegal id \(id)")
                return
            }
            var newLine = templateLine
            newLine.replaceSubrange(range, with: replaceLine.padding(toLength: replaceLen, withPad: " ", startingAt: 0))
            header.append(newLine)
        }
        let indexSet = IndexSet(integersIn: 0..<header.count)
        lines.insert(header, at: indexSet)
    }

}
