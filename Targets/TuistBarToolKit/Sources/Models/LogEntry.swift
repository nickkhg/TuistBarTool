//
//  LogEntry.swift
//  TuistBarTool
//
//  Created by Nick Hagi on 28/11/2023.
//  Copyright © 2023 nickh. All rights reserved..
//

import Foundation

public struct LogEntry: Identifiable, Equatable {
    public let id = UUID()
    public let log: String

    internal init(log: String) {
        self.log = log
    }
}
