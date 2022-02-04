//
//  Aerial_Metrics_Tests.swift
//  Aerial Metrics Tests
//
//  Created by Marcus Rossel on 04.02.22.
//

import XCTest

class Aerial_Metrics_Tests: XCTestCase {

    func testStyleFlattened() {
        let style = Style.bold.italic().backgroundColor(.red).horizontalAlignment(.center)
        let flat = [Style.bold, .italic, .backgroundColor(.red), .horizontalAlignment(.center)]
        XCTAssertEqual(style.flattened, flat)
    }
    
    func testColorArgb() {
        let color1 = Style.Color(red: 1, green: 1, blue: 1)
        let argb1: UInt32 = 0xFFFFFFFF
        XCTAssertEqual(color1.argb, argb1)
        
        let color2 = Style.Color(red: 1, green: 0, blue: 1)
        let argb2: UInt32 = 0xFFFF00FF
        XCTAssertEqual(color2.argb, argb2)
    }
}
