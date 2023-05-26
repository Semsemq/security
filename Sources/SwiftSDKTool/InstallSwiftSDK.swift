//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import ArgumentParser
import Basics
import CoreCommands
import Foundation
import PackageModel

import var TSCBasic.stdoutStream

public struct InstallSwiftSDK: SwiftSDKSubcommand {
    public static let configuration = CommandConfiguration(
        commandName: "install",
        abstract: """
        Installs a given Swift SDK bundle to a location discoverable by SwiftPM. If the artifact bundle \
        is at a remote location, it's downloaded to local filesystem first.
        """
    )

    @OptionGroup(visibility: .hidden)
    var locations: LocationOptions

    @Argument(help: "A local filesystem path or a URL of a Swift SDK bundle to install.")
    var bundlePathOrURL: String

    public init() {}

    func run(
        buildTimeTriple: Triple,
        _ destinationsDirectory: AbsolutePath,
        _ observabilityScope: ObservabilityScope
    ) async throws {
        let cancellator = Cancellator(observabilityScope: observabilityScope)
        cancellator.installSignalHandlers()
        try await SwiftSDKBundle.install(
            bundlePathOrURL: bundlePathOrURL,
            swiftSDKsDirectory: destinationsDirectory,
            self.fileSystem,
            UniversalArchiver(self.fileSystem, cancellator),
            observabilityScope
        )
    }
}
