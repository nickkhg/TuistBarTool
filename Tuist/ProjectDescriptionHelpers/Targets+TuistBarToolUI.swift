//
//  TuistBarToolUITarget.swift
//  ProjectDescriptionHelpers
//
//  Created by Nick Hagi on 30/11/2023.
//

import ProjectDescription

public extension Targets {
    enum TuistBarToolUI {}
}

public extension Targets.TuistBarToolUI {

    private static var settings: SettingsDictionary {
        [
            "ENABLE_HARDENED_RUNTIME": "YES"
        ]
    }

    static var sources: Target {
        Target(
            name: "TuistBarToolUI",
            platform: .macOS,
            product: .framework,
            bundleId: "com.nickh.TuistBarToolUI",
            infoPlist: .default,
            sources: ["Targets/TuistBarToolUI/Sources/**"],
            resources: [],
            dependencies: [.reference(target: Targets.TuistBarToolKit.sources)],
            settings: .settings(base: settings)
        )
    }
}
