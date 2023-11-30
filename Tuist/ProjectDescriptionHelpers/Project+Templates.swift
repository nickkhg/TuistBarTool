import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [String]) -> Project {
        let dep: [TargetDependency] = if name == "TuistBarToolUI" {
            [.target(name: "TuistBarToolKit")]
        } else {
            []
        }
        var targets = makeAppTargets(
            name: name,
            platform: platform,
            dependencies: additionalTargets.map { TargetDependency.target(name: $0) } + dep
        )
        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform) })
        return Project(
            name: name,
            organizationName: "nickh",
            targets: targets
        )
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    public static func makeFrameworkTargets(name: String, platform: Platform, dependencies: [TargetDependency] = []) -> [Target] {
        let sources = Target(
            name: name,
            platform: platform,
            product: .framework,
            bundleId: "com.nickh.\(name)",
            infoPlist: .default,
            sources: ["Targets/\(name)/Sources/**"],
            resources: [],
            dependencies: dependencies
        )
        let tests = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "com.nickh.\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            resources: [],
            dependencies: [.target(name: name)]
        )
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        let infoPlist: [String: Plist.Value] = [
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

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "com.nickh.\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "com.nickh.\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
            ]
        )
        return [mainTarget, testTarget]
    }
}

public enum Targets {}

extension TargetDependency {

    static func reference(target: Target) -> TargetDependency {
        .target(name: target.name)
    }
}
