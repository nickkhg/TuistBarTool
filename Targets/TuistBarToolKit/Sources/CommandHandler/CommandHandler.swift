//
//  CommandHandler.swift
//  TuistBarTool
//
//  Created by Nick Hagi on 28/11/2023.
//  Copyright © 2023 nickh. All rights reserved..
//

import Foundation

public struct CommandHandler {

    public init() {}

    @discardableResult
    private func safeShell(_ command: String) throws -> TuistProcess {
        let process = Process()
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()

        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe
        process.arguments = ["-c", command]
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.standardInput = nil

        try process.run()

        return .init(
            process: process,
            stdoutPipe: stdoutPipe,
            stderrPipe: stderrPipe
        )
    }

    @discardableResult
    public func startProcess(_ command: String, name: String) async throws -> TuistTask {

        let task: Task<TuistProcess, Error> = Task.detached {
            return try self.safeShell(command)
        }

        return TuistTask(name: name, task: task)
    }
}
