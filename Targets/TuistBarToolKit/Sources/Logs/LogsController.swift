//
//  LogsController.swift
//  TuistBarToolKit
//
//  Created by Nick Hagi on 28/11/2023.
//  Copyright © 2023 nickh. All rights reserved.
//

import Foundation

public class LogsController: ObservableObject {
    public static var `default` = LogsController()

    private init() {}

    @Published public private(set) var logs: [LogEntry] = []
    @Published public private(set) var stderrLogs: [LogEntry] = []

    @MainActor public func log(_ stdout: String) {
        logs.append(.init(log: stdout))
    }

    @MainActor public func log(error: String) {
        stderrLogs.append(.init(log: error))
    }

    public func log(_ tuistProcess: TuistProcess) async throws {
        if let stdoutData = try tuistProcess.stdoutPipe.fileHandleForReading.readToEnd(), let stdout = String(data: stdoutData, encoding: .utf8) {
            await self.log(stdout)
        }
        if let stderrData = try tuistProcess.stderrPipe.fileHandleForReading.readToEnd(), let stderr = String(data: stderrData, encoding: .utf8) {
            await self.log(error: stderr)
        }
    }
}
