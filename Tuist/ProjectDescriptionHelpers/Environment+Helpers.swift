//
//  Environment+Helpers.swift
//  ProjectDescriptionHelpers
//
//  Created by Nick Hagi on 30/11/2023.
//

import Foundation
import ProjectDescription

extension Environment {

    static var teamName: String {
        return if case let .string(teamName) = Environment[dynamicMember: "TEAM_NAME"] {
            teamName
        } else if let envTeamName = EnvFileLoader.default.environment["TEAM_NAME"] {
            envTeamName
        } else {
            ""
        }
    }
}

struct EnvFileLoader {

    static let `default` = EnvFileLoader()

    private init() {
        guard let envPath = URL(string: #filePath)? // TODO: Is there a nicer way to do this?
            .deletingLastPathComponent()
            .appending(path: "../../.env")
            .absoluteString
        else {
            print("Could not construct .env path")
            return
        }

        guard
            FileManager.default.fileExists(atPath: envPath),
            let data = try? Data(contentsOf: .init(filePath: envPath)),
            let envContents = String(data: data, encoding: .utf8)
        else {
            print(".env file not found at path \(envPath)")
            return
        }

        environment = envContents // I'm sure there's a nicer way to do this, but it will do for now
            .split(separator: "\n")
            .compactMap { line -> (String, String)? in
                let keyValue = line.split(separator: "=")
                guard let key = keyValue.first else { return nil }
                let value = line.dropFirst(key.count + 1)
                return (String(key), String(value))
            }
            .reduce(into: [:]) { partialResult, keyValue in
                partialResult[keyValue.0] = keyValue.1
            }
    }

    private(set) var environment: [String: String] = [:]
}
