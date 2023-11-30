import ProjectDescription

public enum Targets {}

extension TargetDependency {

    static func reference(target: Target) -> TargetDependency {
        .target(name: target.name)
    }
}
