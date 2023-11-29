//
//  TuistProcess.swift
//  TuistBarTool
//
//  Created by Nick Hagi on 28/11/2023.
//  Copyright © 2023 nickh. All rights reserved..
//

import Foundation

public struct TuistProcess {
    public let process: Process
    public let stdoutPipe: Pipe
    public let stderrPipe: Pipe


    public init(process: Process, stdoutPipe: Pipe, stderrPipe: Pipe) {
        self.process = process
        self.stdoutPipe = stdoutPipe
        self.stderrPipe = stderrPipe
    }

}
