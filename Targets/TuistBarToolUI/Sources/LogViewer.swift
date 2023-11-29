//
//  LogViewer.swift
//  TuistBarToolKit
//
//  Created by Nick Hagi on 28/11/2023.
//  Copyright © 2023 nickh. All rights reserved..
//

import SwiftUI
import TuistBarToolKit

public struct LogViewer: View {

    @ObservedObject private var logs = LogsController.default
    public init() {}

    public var body: some View {
        HStack {
            List {
                Section(header: Text("Stdout")) {
                    ForEach(logs.logs) { log in
                        Text(log.log)
                    }
                }
            }
            List {
                Section(header: Text("Stderr")) {
                    ForEach(logs.stderrLogs) { log in
                        Text(log.log)
                    }
                }
            }
        }
    }
}
