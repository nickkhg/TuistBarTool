//
//  TuistBarToolTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by Nick Hagi on 30/11/2023.
//

import ProjectDescription

public extension Targets {
    enum App { }
}

public extension Targets.App {

    private static var infoPlist: [String: Plist.Value] {
        [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "NSMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "LSUIElement": "YES",
            "CFBundleURLTypes": [
                [
                    "CFBundleURLSchemes": [
                        "tuistbartool"
                    ]
                ]
            ]
        ]
    }

    private static var settings: SettingsDictionary {
        [
            "ENABLE_HARDENED_RUNTIME": "YES",
            "DEVELOPMENT_TEAM": .string(Environment.teamName)
        ]
    }

    static var sources: Target {
        Target(
            name: "TuistBarTool",
            platform: .macOS,
            product: .app,
            bundleId: "com.nickh.TuistBarTool",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/TuistBarTool/Sources/**"],
            resources: ["Targets/TuistBarTool/Resources/**"],
            dependencies: [
                .reference(target: Targets.TuistBarToolKit.sources),
                .target(name: "TuistBarToolUI")
            ],
            settings: .settings(base: settings, defaultSettings: .recommended)
        )
    }
}
