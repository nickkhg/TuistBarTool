//
//  TuistBarToolKitTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by Nick Hagi on 30/11/2023.
//

import ProjectDescription

public extension Targets {
    enum TuistBarToolKit {}
}

public extension Targets.TuistBarToolKit {

    private static var settings: SettingsDictionary {
        [
            "ENABLE_HARDENED_RUNTIME": "YES"
        ]
    }

    static var sources: Target {
        Target(
            name: "TuistBarToolKit",
            platform: .macOS,
            product: .framework,
            bundleId: "com.nickh.TuistBarToolKit",
            infoPlist: .default,
            sources: ["Targets/TuistBarToolKit/Sources/**"],
            resources: [],
            dependencies: [],
            settings: .settings(base: settings)
        )
    }

    static var tests: Target {
        Target(
            name: "TuistBarToolKitTests",
            platform: .macOS,
            product: .unitTests,
            bundleId: "com.nickh.TuistBarToolKitTests",
            infoPlist: .default,
            sources: ["Targets/TuistBarToolKit/Tests/**"],
            resources: [],
            dependencies: [.reference(target: Targets.TuistBarToolKit.sources)],
            settings: .settings(base: settings)
        )
    }
}
