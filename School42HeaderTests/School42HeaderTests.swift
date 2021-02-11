//
//  School42HeaderTests.swift
//  School42HeaderTests
//
//  Created by Dmitriy Borovikov on 04.01.2021.
//


import XCTest
@testable import School42Header

class School42HeaderTests: XCTestCase {

    let sample42Header = """
    /* ************************************************************************** */
    /*                                                                            */
    /*                                                        :::      ::::::::   */
    /*   ft_file.c                                          :+:      :+:    :+:   */
    /*                                                    +:+ +:+         +:+     */
    /*   By: User <user@42.fr>                          +#+  +:+       +#+        */
    /*                                                +#+#+#+#+#+   +#+           */
    /*   Created: 2021/01/04 14:15:30 by User              #+#    #+#             */
    /*   Updated: 2021/01/04 14:15:30 by User             ###   ########.fr       */
    /*                                                                            */
    /* ************************************************************************** */
    """
    let sampleXcode12Header = """
    //
    //  ft_file.c
    //  ft_project
    //
    //  Created by User on 04.01.2021.
    //

    #include "ft_file.h"
    """

    let sampleXcodeHeader = """
    //
    //  ft_file.c
    //  ft_project
    //
    //  Created by User on 04.01.2021.
    //  Copyright © 2021 User. All rights reserved.
    //

    #include "ft_file.h"
    """

    var sampleDate: Date!
    var sample42HeaderLines = NSMutableArray()
    var sampleXcodeHeaderLines = NSMutableArray()
    var sampleXcode12HeaderLines = NSMutableArray()
    var header42: Header42!

    override func setUp() {
        sample42HeaderLines = NSMutableArray(array: sample42Header.split(separator: "\n", omittingEmptySubsequences: false).map{ $0 + "\n"})
        sampleXcodeHeaderLines = NSMutableArray(array: sampleXcodeHeader.split(separator: "\n", omittingEmptySubsequences: false).map{ $0 + "\n"})
        sampleXcode12HeaderLines = NSMutableArray(array: sampleXcode12Header.split(separator: "\n", omittingEmptySubsequences: false).map{ $0 + "\n"})
        header42 = Header42({ () -> Date in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            return formatter.date(from: "2021/01/04 14:15:30")!
        })
    }

    func testXcodeCheckHeader() {
        let sampleHeader = sampleXcodeHeaderLines
        XCTAssertTrue(header42.isHeaderXcode(in: sampleHeader))
        sampleHeader.removeObject(at: 0)
        XCTAssertFalse(header42.isHeaderXcode(in: sampleHeader))
    }

    func testXcode12CheckHeader() {
        let sampleHeader = sampleXcode12HeaderLines
        XCTAssertTrue(header42.isHeaderXcode(in: sampleHeader))
        sampleHeader.removeObject(at: 0)
        XCTAssertFalse(header42.isHeaderXcode(in: sampleHeader))
    }

    func test42CheckHeader() {
        XCTAssertTrue(header42.isHeader42(in: sample42HeaderLines))
        sample42HeaderLines.removeObject(at: 0)
        XCTAssertFalse(header42.isHeader42(in: sample42HeaderLines))
    }

    func testXcodeHeader() {
        let sampleHeader = sampleXcodeHeaderLines
        let filename = header42.getFilename(from: sampleHeader)
        XCTAssertEqual(filename, "ft_file.c")

        let result = NSMutableArray()
        result.add("\n")
        result.add("#include \"ft_file.h\"\n")
        header42.removeHeaderXcode(in: sampleHeader)
        XCTAssertEqual(sampleHeader, result)
    }

    func testXcode12Header() {
        let sampleHeader = sampleXcode12HeaderLines
        let filename = header42.getFilename(from: sampleHeader)
        XCTAssertEqual(filename, "ft_file.c")

        let result = NSMutableArray()
        result.add("\n")
        result.add("#include \"ft_file.h\"\n")
        header42.removeHeaderXcode(in: sampleHeader)
        XCTAssertEqual(sampleHeader, result)
    }

    func testInsertHeader() {
        let result = NSMutableArray()
        header42.insertHeader42(filename: "ft_file.c", username: "User", email: "user@42.fr", in: result)
        XCTAssertEqual(result, sample42HeaderLines)
    }

    func testUpdateHeader() {
        let sampleDateString = "2021/01/04 15:30:40"
        header42 = Header42 { () -> Date in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            return formatter.date(from: sampleDateString)!
        }

        let result = NSMutableArray(array: sample42HeaderLines as! Array<String> , copyItems: true)
        header42.updateHeader42(username: "someuser",in: sample42HeaderLines)
        XCTAssertNotEqual(result, sample42HeaderLines)

        result[8] = "/*   Updated: 2021/01/04 15:30:40 by someuser         ###   ########.fr       */\n"

        XCTAssertEqual(result, sample42HeaderLines)
    }
}
