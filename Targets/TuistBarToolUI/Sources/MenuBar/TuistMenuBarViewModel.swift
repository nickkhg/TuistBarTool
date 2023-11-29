//
//  TuistMenuBarViewModel.swift
//  TuistBarTool
//
//  Created by Nick Hagi on 28/11/2023.
//  Copyright © 2023 nickh. All rights reserved..
//

import AppKit
import Observation
import TuistBarToolKit
import Combine

class TuistMenuBarViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var selectedProject: UUID?
    @Published var tasks: [TuistTask] = []
    @Published var error: Error?

    var activeProject: Project? {
        projects.first { $0.id == selectedProject }
    }

    private let commandHandler: CommandHandler
    private let logsController: LogsController

    private var subscriptions: Set<AnyCancellable> = []

    init(commandHandler: CommandHandler = .init(), logsController: LogsController = .default) {
        self.commandHandler = commandHandler
        self.logsController = logsController
        self.loadProjects()

        self.$selectedProject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self else { return }
                UserDefaults.standard.setValue(selectedProject?.uuidString, forKey: "selected_project")

            }
            .store(in: &subscriptions)
    }

    private func saveProjects() {
        guard let data = try? JSONEncoder().encode(projects) else { return }
        UserDefaults.standard.setValue(data, forKey: "saved_projects")
    }

    private func loadProjects() {
        guard 
            let data = UserDefaults.standard.object(forKey: "saved_projects") as? Data,
            let projects = try? JSONDecoder().decode([Project].self, from: data)
        else { return }

        self.projects = projects
        let uuidString = UserDefaults.standard.string(forKey: "selected_project")
        self.selectedProject = uuidString.map { UUID(uuidString: $0) } ?? nil
    }

    private func addProject(url: URL) {
        let project = Project(id: .init(), path: url)
        projects.append(project)
        selectedProject = project.id
        saveProjects()
    }

    @MainActor private func addTask(_ task: TuistTask) {
        tasks.append(task)
    }

    @MainActor private func removeTask(_ task: TuistTask) {
        tasks.removeAll { $0.id == task.id }
    }

    // MARK: - Intents
    @MainActor func addProjectMenuOptionClicked() {

        let folderChooserPoint = CGPoint(x: 0, y: 0)
        let folderChooserSize = CGSize(width: 500, height: 600)
        let folderChooserRectangle = CGRect(origin: folderChooserPoint, size: folderChooserSize)
        let folderPicker = NSOpenPanel(contentRect: folderChooserRectangle, styleMask: .utilityWindow, backing: .buffered, defer: true)

        folderPicker.canChooseDirectories = true
        folderPicker.canChooseFiles = false
        folderPicker.allowsMultipleSelection = false
        folderPicker.canDownloadUbiquitousContents = true
        folderPicker.canResolveUbiquitousConflicts = true

        folderPicker.begin { [weak self] response in

            if response == .OK {
                guard let pickedFolder = folderPicker.urls.first else { return }
                self?.addProject(url: pickedFolder)
            }
        }
    }

    func generateOptionClicked() async {
        guard let activeProject else { return }
        do {
            let tuistTask = try await commandHandler.startProcess(
                "cd \(activeProject.path.path()) && /usr/local/bin/tuist generate",
                name: "Generate"
            )

            await addTask(tuistTask)

            let tuistProcess = try await tuistTask.task.value

            try await logsController.log(tuistProcess)

            await removeTask(tuistTask)
        } catch {
            self.error = error
            print(error)
        }
    }

    func fetchOptionClicked() async {
        guard let activeProject else { return }
        do {
            let tuistTask = try await commandHandler.startProcess(
                "cd \(activeProject.path.path()) && /usr/local/bin/tuist fetch",
                name: "Generate"
            )

            await addTask(tuistTask)

            _ = await tuistTask.task.result

            await removeTask(tuistTask)

        } catch {
            self.error = error
            print(error)
        }
    }

    func fetchAndGenerateOptionClicked() async {
        guard let activeProject else { return }
        do {
            let tuistTask = try await commandHandler.startProcess(
                "cd \(activeProject.path.path()) && /usr/local/bin/tuist fetch && /usr/local/bin/tuist generate",
                name: "Fetch And Generate"
            )

            await addTask(tuistTask)

            let tuistProcess = try await tuistTask.task.value

            try await logsController.log(tuistProcess)

            await removeTask(tuistTask)

        } catch {
            self.error = error
            print(error)
        }
    }

    func editOptionClicked() async {
        guard let activeProject else { return }
        do {
            let tuistTask = try await commandHandler.startProcess(
                "cd \(activeProject.path.path()) && /usr/local/bin/tuist edit",
                name: "Edit"
            )

            await addTask(tuistTask)

        } catch {
            self.error = error
            print(error)
        }

    }

    func processOptionClicked(_ tuistTask: TuistTask) async {

        guard let tuistProcess = try? await tuistTask.task.value else { return }
        tuistProcess.process.interrupt()

        await removeTask(tuistTask)
    }

    func interruptAllClicked() async {
        do {
            let tuistTask = try await commandHandler.startProcess(
                "killall -2 tuist",
                name: "Kill All Tuist"
            )

            await addTask(tuistTask)

            let tuistProcess = try await tuistTask.task.value

            try await logsController.log(tuistProcess)

            await removeTask(tuistTask)

        } catch {
            self.error = error
            print(error)
        }
    }
}
