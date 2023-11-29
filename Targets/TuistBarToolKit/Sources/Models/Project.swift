//
//  Project.swift
//  TuistBarTool
//
//  Created by Nick Hagi on 28/11/2023.
//  Copyright © 2023 nickh. All rights reserved..
//

import Foundation

public struct Project: Codable, Identifiable {
    public let id: UUID
    public let path: URL

    public var name: String {
        path.lastPathComponent
    }

    public init(id: UUID, path: URL) {
        self.id = id
        self.path = path
    }

}
