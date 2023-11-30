import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "TuistBarTool",
    organizationName: "nickh",
    targets: [
        Targets.App.sources,
        Targets.TuistBarToolKit.sources,
        Targets.TuistBarToolKit.tests,
        Targets.TuistBarToolUI.sources,
    ]
)
