//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import Basics
import XCTest

final class TripleTests: XCTestCase {
    func testIsAppleIsDarwin() {
        func XCTAssertTriple(
            _ triple: String,
            isApple: Bool,
            isDarwin: Bool,
            file: StaticString = #filePath,
            line: UInt = #line
        ) {
            guard let triple = try? Triple(triple) else {
                XCTFail(
                    "Unknown triple '\(triple)'.",
                    file: file,
                    line: line)
                return
            }
            XCTAssert(
                isApple == triple.isApple(),
                """
                Expected triple '\(triple.tripleString)' \
                \(isApple ? "" : " not") to be an Apple triple.
                """,
                file: file,
                line: line)
            XCTAssert(
                isDarwin == triple.isDarwin(),
                """
                Expected triple '\(triple.tripleString)' \
                \(isDarwin ? "" : " not") to be a Darwin triple.
                """,
                file: file,
                line: line)
        }
        
        XCTAssertTriple("x86_64-pc-linux-gnu", isApple: false, isDarwin: false)
        XCTAssertTriple("x86_64-pc-linux-musl", isApple: false, isDarwin: false)
        XCTAssertTriple("powerpc-bgp-linux", isApple: false, isDarwin: false)
        XCTAssertTriple("arm-none-none-eabi", isApple: false, isDarwin: false)
        XCTAssertTriple("arm-none-linux-musleabi", isApple: false, isDarwin: false)
        XCTAssertTriple("wasm32-unknown-wasi", isApple: false, isDarwin: false)
        XCTAssertTriple("riscv64-unknown-linux", isApple: false, isDarwin: false)
        XCTAssertTriple("mips-mti-linux-gnu", isApple: false, isDarwin: false)
        XCTAssertTriple("mipsel-img-linux-gnu", isApple: false, isDarwin: false)
        XCTAssertTriple("mips64-mti-linux-gnu", isApple: false, isDarwin: false)
        XCTAssertTriple("mips64el-img-linux-gnu", isApple: false, isDarwin: false)
        XCTAssertTriple("mips64el-img-linux-gnuabin32", isApple: false, isDarwin: false)
        XCTAssertTriple("mips64-unknown-linux-gnuabi64", isApple: false, isDarwin: false)
        XCTAssertTriple("mips64-unknown-linux-gnuabin32", isApple: false, isDarwin: false)
        XCTAssertTriple("mipsel-unknown-linux-gnu", isApple: false, isDarwin: false)
        XCTAssertTriple("mips-unknown-linux-gnu", isApple: false, isDarwin: false)
        XCTAssertTriple("arm-oe-linux-gnueabi", isApple: false, isDarwin: false)
        XCTAssertTriple("aarch64-oe-linux", isApple: false, isDarwin: false)
        XCTAssertTriple("armv7em-unknown-none-macho", isApple: false, isDarwin: false)
        XCTAssertTriple("armv7em-apple-none-macho", isApple: true, isDarwin: false)
        XCTAssertTriple("armv7em-apple-none", isApple: true, isDarwin: false)
        XCTAssertTriple("aarch64-apple-macosx", isApple: true, isDarwin: true)
        XCTAssertTriple("x86_64-apple-macosx", isApple: true, isDarwin: true)
        XCTAssertTriple("x86_64-apple-macosx10.15", isApple: true, isDarwin: true)
        XCTAssertTriple("x86_64h-apple-darwin", isApple: true, isDarwin: true)
        XCTAssertTriple("i686-pc-windows-msvc", isApple: false, isDarwin: false)
        XCTAssertTriple("i686-pc-windows-gnu", isApple: false, isDarwin: false)
        XCTAssertTriple("i686-pc-windows-cygnus", isApple: false, isDarwin: false)
    }
    
    func testDescription() throws {
        let triple = try Triple("x86_64-pc-linux-gnu")
        XCTAssertEqual("foo \(triple) bar", "foo x86_64-pc-linux-gnu bar")
    }

    func testTripleStringForPlatformVersion() throws {
        func XCTAssertTriple(
            _ triple: String,
            forPlatformVersion version: String,
            is expectedTriple: String,
            file: StaticString = #filePath,
            line: UInt = #line
        ) {
            guard let triple = try? Triple(triple) else {
                XCTFail("Unknown triple '\(triple)'.", file: file, line: line)
                return
            }
            let actualTriple = triple.tripleString(forPlatformVersion: version)
            XCTAssert(
                actualTriple == expectedTriple,
                """
                Actual triple '\(actualTriple)' did not match expected triple \
                '\(expectedTriple)' for platform version '\(version)'.
                """,
                file: file,
                line: line)
        }

        XCTAssertTriple("x86_64-apple-macosx", forPlatformVersion: "", is: "x86_64-apple-macosx")
        XCTAssertTriple("x86_64-apple-macosx", forPlatformVersion: "13.0", is: "x86_64-apple-macosx13.0")

        XCTAssertTriple("armv7em-apple-macosx10.12", forPlatformVersion: "", is: "armv7em-apple-macosx")
        XCTAssertTriple("armv7em-apple-macosx10.12", forPlatformVersion: "13.0", is: "armv7em-apple-macosx13.0")

        XCTAssertTriple("powerpc-apple-macos", forPlatformVersion: "", is: "powerpc-apple-macos")
        XCTAssertTriple("powerpc-apple-macos", forPlatformVersion: "13.0", is: "powerpc-apple-macos13.0")

        XCTAssertTriple("i686-apple-macos10.12.0", forPlatformVersion: "", is: "i686-apple-macos")
        XCTAssertTriple("i686-apple-macos10.12.0", forPlatformVersion: "13.0", is: "i686-apple-macos13.0")

        XCTAssertTriple("riscv64-apple-darwin", forPlatformVersion: "", is: "riscv64-apple-darwin")
        XCTAssertTriple("riscv64-apple-darwin", forPlatformVersion: "22", is: "riscv64-apple-darwin22")

        XCTAssertTriple("mips-apple-darwin19", forPlatformVersion: "", is: "mips-apple-darwin")
        XCTAssertTriple("mips-apple-darwin19", forPlatformVersion: "22", is: "mips-apple-darwin22")
    }
}
