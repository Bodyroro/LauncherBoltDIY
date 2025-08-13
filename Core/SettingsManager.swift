//
//  SettingsManager.swift
//  LauncherBoltDIY
//
//  Created by Bodyroro on 12/08/2025.
//  Copyright © 2025 Bodyroro. All rights reserved.
//

import Foundation
import Combine

// SettingsManager gère la persistance des paramètres de l'application.
// Il utilise UserDefaults pour sauvegarder et charger les chemins des exécutables.
class SettingsManager: ObservableObject {

    // Instance unique (singleton) pour un accès facile depuis n'importe où.
    static let shared = SettingsManager()

    // Clés pour UserDefaults
    private let gitPathKey = "gitPath"
    private let nodePathKey = "nodePath"
    private let pnpmPathKey = "pnpmPath"
    private let projectFolderKey = "projectFolder"

    // Les propriétés sont @Published pour mettre à jour les vues qui les observent.
    @Published var gitPath: String {
        didSet {
            UserDefaults.standard.set(gitPath, forKey: gitPathKey)
        }
    }

    @Published var nodePath: String {
        didSet {
            UserDefaults.standard.set(nodePath, forKey: nodePathKey)
        }
    }

    @Published var pnpmPath: String {
        didSet {
            UserDefaults.standard.set(pnpmPath, forKey: pnpmPathKey)
        }
    }

    @Published var projectFolderPath: String {
        didSet {
            UserDefaults.standard.set(projectFolderPath, forKey: projectFolderKey)
        }
    }

    // Initialiseur qui charge les paramètres sauvegardés ou utilise les valeurs par défaut.
    private init() {
        self.gitPath = UserDefaults.standard.string(forKey: gitPathKey) ?? "/usr/bin/git"
        self.nodePath = UserDefaults.standard.string(forKey: nodePathKey) ?? "/usr/local/bin/node"
        self.pnpmPath = UserDefaults.standard.string(forKey: pnpmPathKey) ?? "/usr/local/bin/pnpm"
        self.projectFolderPath = UserDefaults.standard.string(forKey: projectFolderKey) ?? "Documents"
    }

    // Restaure les chemins par défaut.
    func restoreDefaults() {
        self.gitPath = "/usr/bin/git"
        self.nodePath = "/usr/local/bin/node"
        self.pnpmPath = "/usr/local/bin/pnpm"
        self.projectFolderPath = "Documents"
    }
}
