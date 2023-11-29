//
//  WindowManager.swift
//  TuistBarToolKit
//
//  Created by Nick Hagi on 29/11/2023.
//  Copyright © 2023 nickh. All rights reserved..
//

import AppKit

public enum WindowManager: String, CaseIterable {
    case LogViewer = "LogViewer"

    func open(){
        if let url = URL(string: "tuistbartool://\(self.rawValue)") { //replace myapp with your app's name
            NSWorkspace.shared.open(url)
        }
    }
}
