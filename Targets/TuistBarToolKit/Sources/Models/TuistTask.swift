//
//  TuistTask.swift
//  TuistBarTool
//
//  Created by Nick Hagi on 28/11/2023.
//  Copyright © 2023 nickh. All rights reserved..
//

import Foundation

public struct TuistTask: Identifiable {
    
    public let id = UUID()
    public let name: String
    public let task: Task<TuistProcess, Error>

    internal init(name: String, task: Task<TuistProcess, Error>) {
        self.name = name
        self.task = task
    }
}
