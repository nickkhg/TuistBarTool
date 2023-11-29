//
//  TuistMenuBar.swift
//  TuistBarTool
//
//  Created by Nick Hagi on 28/11/2023.
//  Copyright © 2023 nickh. All rights reserved..
//

import SwiftUI
import TuistBarToolKit

struct TuistMenuBarContents: View {

    @StateObject var viewModel: TuistMenuBarViewModel = .init()
    @ObservedObject var logs: LogsController = LogsController.default

    var projectSelection: some View {
        Menu(viewModel.activeProject?.name ?? "Select Project") {
            Picker("Active Project", selection: $viewModel.selectedProject) {
                ForEach(viewModel.projects, id: \.id) { project in
                    Text(project.name)
                        .tag(project.id as UUID?)
                }
            }
            .pickerStyle(.inline)
            Divider()
            Button("Add Project") {
                viewModel.addProjectMenuOptionClicked()
            }
        }
    }

    var runningTasks: some View {
        Menu("Running Tasks") {
            ForEach(viewModel.tasks) { process in
                Button(process.name) {
                    Task {
                        await viewModel.processOptionClicked(process)
                    }
                }

            }
            Divider()
            Button(
                "\(Image(systemName: "exclamationmark.triangle.fill")) Interrupt all Tuist processes"
            ) {
                Task {
                    await viewModel.interruptAllClicked()
                }
            }
            .foregroundStyle(.red)
        }
    }

    @ViewBuilder
    var tuistActions: some View {
        Button("Generate") {
            Task {
                await viewModel.generateOptionClicked()
            }
        }
        .disabled(viewModel.selectedProject == nil)
        Button("Fetch") {
            Task {
                await viewModel.fetchOptionClicked()
            }
        }
        .disabled(viewModel.selectedProject == nil)
        Button("Fetch & Generate") {
            Task {
                await viewModel.fetchAndGenerateOptionClicked()
            }
        }
        .disabled(viewModel.selectedProject == nil)
        Button("Edit") {
            Task {
                await viewModel.editOptionClicked()
            }
        }
        .disabled(viewModel.selectedProject == nil)
        .keyboardShortcut(.init("e", modifiers: [.command, .control]))
    }

    var body: some View {
        Group {
            projectSelection
            Divider()
            runningTasks
            tuistActions
            Divider()
            Button("Open Logs") {
                WindowManager.LogViewer.open()
            }
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .onChange(of: logs.stderrLogs) {
            WindowManager.LogViewer.open()
        }
    }
}

public struct TuistMenuBar: Scene {

    public init() {}
    public var body: some Scene {
        MenuBarExtra {
            TuistMenuBarContents()
        } label: {
            Image(systemName: "books.vertical")
        }
        .menuBarExtraStyle(.automatic)
    }
}
