//
//  ViewModel.swift
//  LauncherBoltDIY
//
//  Created by Bodyroro on 12/08/2025.
//  Copyright © 2025 Bodyroro. All rights reserved.
//

import Foundation
import Combine
import AppKit

// Le ViewModel est une classe ObservableObject qui gère la logique de l'application et l'état.
class ViewModel: ObservableObject {
    
    // MARK: - Propriétés d'état
    
    // @Published pour notifier les vues des changements.
    @Published var consoleLog: String = Localizable.generalLog
    @Published var localCommit: String = "..."
    @Published var remoteCommit: String = "..."
    @Published var isProjectInstalled: Bool = false
    @Published var isUpdateAvailable: Bool = false
    @Published var serverProcess: Process? = nil
    @Published var isProcessing: Bool = false
    @Published var isCheckingCommits: Bool = false

    // Le chemin complet du dossier du projet, calculé dynamiquement.
    var projectPath: String {
        return NSHomeDirectory() + "/\(SettingsManager.shared.projectFolderPath)/\(Configuration.nomDossierProjet)"
    }

    // MARK: - Initialisation

    // L'initialiseur met à jour l'état initial de l'application.
    init() {
        updateProjectState()
        updateCommitInfo()
    }

    // MARK: - Fonctions utilitaires

    // Ajoute un message à la console de manière sécurisée sur le thread principal.
    func appendToLog(_ message: String) {
        DispatchQueue.main.async {
            self.consoleLog += "\(message)\n"
        }
    }

    // Met à jour l'état du projet (installé ou non) en vérifiant l'existence du dossier.
    func updateProjectState() {
        isProjectInstalled = FileManager.default.fileExists(atPath: projectPath)
    }

    // Vide la console avant d'exécuter une nouvelle action.
    func resetConsole() {
        consoleLog = ""
    }

    // Vérifie si un exécutable existe au chemin spécifié.
    func checkExecutableExistence(atPath path: String) -> Bool {
        if !FileManager.default.fileExists(atPath: path) {
            appendToLog(Localizable.executableNotFound(path: path))
            return false
        }
        return true
    }

    // Récupère le PATH de l'utilisateur pour que les commandes fonctionnent correctement.
    private func getShellPath() -> String {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["sh", "-l", "-c", "echo $PATH"]

        let pipe = Pipe()
        task.standardOutput = pipe

        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        } catch {
            return "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        }
    }

    // Exécute une commande de manière asynchrone et affiche le flux en temps réel.
    func runCommandAsync(path: String, args: [String], currentDirectory: String? = nil, onCompletion: ((Int32) -> Void)?) {
        guard checkExecutableExistence(atPath: path) else {
            onCompletion?(1)
            return
        }

        let task = Process()
        task.launchPath = path
        task.arguments = args
        task.environment = ["PATH": getShellPath()]

        if let directory = currentDirectory {
            task.currentDirectoryPath = directory
        }

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        let outputHandle = pipe.fileHandleForReading
        outputHandle.waitForDataInBackgroundAndNotify()

        appendToLog(Localizable.executingCommandLog + "\(path) \(args.joined(separator: " "))")

        NotificationCenter.default.addObserver(forName: .NSFileHandleDataAvailable, object: outputHandle, queue: nil) { notification in
            let data = outputHandle.availableData
            guard !data.isEmpty else {
                return
            }

            if let output = String(data: data, encoding: .utf8) {
                self.appendToLog(output)
            }
            outputHandle.waitForDataInBackgroundAndNotify()
        }

        task.terminationHandler = { process in
            DispatchQueue.main.async {
                onCompletion?(process.terminationStatus)
                NotificationCenter.default.removeObserver(self, name: .NSFileHandleDataAvailable, object: outputHandle)
            }
        }

        do {
            try task.run()
        } catch {
            appendToLog(Localizable.commandFailedLog + error.localizedDescription)
            onCompletion?(1)
        }
    }

    // Exécute une commande de manière synchrone et renvoie sa sortie.
    func runCommandSync(path: String, args: [String], currentDirectory: String? = nil) -> String? {
        guard checkExecutableExistence(atPath: path) else {
            return nil
        }

        let task = Process()
        task.launchPath = path
        task.arguments = args
        task.environment = ["PATH": getShellPath()]

        if let directory = currentDirectory {
            task.currentDirectoryPath = directory
        }

        let pipe = Pipe()
        task.standardOutput = pipe

        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)
            return output
        } catch {
            appendToLog(Localizable.commandFailedLog + error.localizedDescription)
            return nil
        }
    }

    // Formate une chaîne de commit pour n'afficher que les 7 premiers caractères.
    func formatCommit(_ commit: String) -> String {
        let length = 7
        if commit == Localizable.notAvailable || commit == Localizable.error || commit == "..." {
            return String(commit.padding(toLength: length, withPad: " ", startingAt: 0))
        } else if commit.count > length {
            return String(commit.prefix(length))
        } else {
            return String(commit.padding(toLength: length, withPad: " ", startingAt: 0))
        }
    }

    // MARK: - Fonctions de gestion du projet

    // Installe le projet Bolt DIY.
    func setupBoltDIY() {
        resetConsole()
        appendToLog(Localizable.installLog)

        guard !isProcessing else { return }
        isProcessing = true

        guard !FileManager.default.fileExists(atPath: projectPath) else {
            appendToLog(Localizable.projectExists)
            isProcessing = false
            return
        }

        // Étape 1: Clonage du dépôt
        appendToLog(Localizable.cloningStarted)
        runCommandAsync(path: SettingsManager.shared.gitPath, args: ["clone", Configuration.urlDepotGit, projectPath]) { status in
            guard status == 0 else {
                self.appendToLog(Localizable.cloningFailed(code: status))
                self.isProcessing = false
                return
            }
            self.appendToLog(Localizable.cloningSuccess)

            // Étape 2: Installation des dépendances
            self.appendToLog(Localizable.pnpmInstallStarted)
            self.runCommandAsync(path: SettingsManager.shared.pnpmPath, args: ["install"], currentDirectory: self.projectPath) { pnpmStatus in
                defer { self.isProcessing = false }
                guard pnpmStatus == 0 else {
                    self.appendToLog(Localizable.pnpmInstallFailed(code: pnpmStatus))
                    return
                }
                self.appendToLog(Localizable.pnpmInstallSuccess)

                self.updateProjectState()
                self.updateCommitInfo()
            }
        }
    }

    // Lance le serveur de développement.
    func launchBoltDIY() {
        resetConsole()
        appendToLog(Localizable.launchLog)

        guard !isProcessing else { return }
        
        guard isProjectInstalled else {
            appendToLog(Localizable.projectNotFound)
            return
        }

        guard serverProcess == nil else {
            appendToLog(Localizable.serverAlreadyRunning)
            return
        }

        // Création du processus
        let task = Process()
        task.launchPath = SettingsManager.shared.pnpmPath
        task.currentDirectoryPath = projectPath
        task.arguments = ["run", "dev"]
        task.environment = ["PATH": getShellPath()]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        let outputHandle = pipe.fileHandleForReading
        outputHandle.waitForDataInBackgroundAndNotify()

        // Lecture du flux de sortie en temps réel
        NotificationCenter.default.addObserver(forName: .NSFileHandleDataAvailable, object: outputHandle, queue: nil) { notification in
            let data = outputHandle.availableData
            guard !data.isEmpty else { return }

            if let output = String(data: data, encoding: .utf8) {
                self.appendToLog(output)
            }
            outputHandle.waitForDataInBackgroundAndNotify()
        }

        task.terminationHandler = { process in
            DispatchQueue.main.async {
                self.serverProcess = nil
                self.appendToLog(Localizable.processTerminated)
                self.updateProjectState()
            }
        }

        do {
            appendToLog(Localizable.serverStartLog)
            try task.run()
            self.serverProcess = task
            appendToLog(Localizable.serverStartSuccess)
        } catch {
            appendToLog(Localizable.serverStartFailed)
            appendToLog(Localizable.commandFailedLog + error.localizedDescription)
            self.serverProcess = nil
        }
    }

    // Arrête le serveur de développement.
    func stopBoltDIY() {
        resetConsole()
        appendToLog(Localizable.stopLog)

        guard let process = serverProcess else {
            appendToLog(Localizable.serverStopFailed)
            return
        }

        appendToLog(Localizable.serverStopLog)
        process.terminate()
        serverProcess = nil
        appendToLog(Localizable.serverStopSuccess)
    }

    // Met à jour le projet en utilisant Git.
    func updateProject() {
        resetConsole()
        appendToLog(Localizable.updateLog)
        
        guard !isProcessing else { return }
        isProcessing = true
        
        guard isProjectInstalled else {
            appendToLog(Localizable.projectNotFound)
            isProcessing = false
            return
        }

        appendToLog(Localizable.updateStarted)

        runCommandAsync(path: SettingsManager.shared.gitPath, args: ["pull"], currentDirectory: projectPath) { status in
            defer { self.isProcessing = false }
            guard status == 0 else {
                self.appendToLog(Localizable.updateFailed(code: status))
                return
            }
            self.appendToLog(Localizable.updateSuccess)
            self.updateCommitInfo()
        }
    }

    // Supprime le dossier du projet.
    func deleteProject() {
        resetConsole()
        appendToLog(Localizable.deleteLog)
        
        guard !isProcessing else { return }
        isProcessing = true
        
        guard isProjectInstalled else {
            appendToLog(Localizable.projectNotFound)
            isProcessing = false
            return
        }

        appendToLog(Localizable.deleteStarted)
        do {
            try FileManager.default.removeItem(atPath: projectPath)
            appendToLog(Localizable.deleteSuccess)

            localCommit = formatCommit("...")
            remoteCommit = formatCommit("...")
            updateProjectState()
        } catch {
            appendToLog(Localizable.deleteFailed(error: error.localizedDescription))
        }
        
        isProcessing = false
    }

    // Met à jour les informations de commit.
    func updateCommitInfo() {
        appendToLog(Localizable.checkLog)
        guard !isCheckingCommits else { return }
        isCheckingCommits = true
        
        DispatchQueue.global(qos: .background).async {
            // Récupère le commit distant en premier lieu
            let remoteOutput = self.runCommandSync(path: SettingsManager.shared.gitPath, args: ["ls-remote", Configuration.urlDepotGit, "HEAD"])
            let remoteCommitFull = remoteOutput?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .whitespaces).first
            
            DispatchQueue.main.async {
                self.remoteCommit = self.formatCommit(remoteCommitFull ?? Localizable.error)
            }

            // Si le projet n'est pas installé, pas de vérification locale
            guard self.isProjectInstalled else {
                DispatchQueue.main.async {
                    self.localCommit = self.formatCommit(Localizable.notAvailable)
                    self.isUpdateAvailable = false
                    self.isCheckingCommits = false
                }
                return
            }

            // Si le projet est installé, on effectue les vérifications complètes
            self.runCommandAsync(path: SettingsManager.shared.gitPath, args: ["fetch", "--quiet"], currentDirectory: self.projectPath) { _ in
                let statusOutput = self.runCommandSync(path: SettingsManager.shared.gitPath, args: ["status", "--porcelain"], currentDirectory: self.projectPath)
                let isRepoDirty = statusOutput?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false

                let localOutput = self.runCommandSync(path: SettingsManager.shared.gitPath, args: ["rev-parse", "--short", "HEAD"], currentDirectory: self.projectPath)
                let localCommitHash = localOutput?.trimmingCharacters(in: .whitespacesAndNewlines) ?? Localizable.error
                
                let remoteTrackedOutput = self.runCommandSync(path: SettingsManager.shared.gitPath, args: ["rev-parse", "--short", "@{u}"], currentDirectory: self.projectPath)
                let remoteTrackedHash = remoteTrackedOutput?.trimmingCharacters(in: .whitespacesAndNewlines) ?? Localizable.error

                DispatchQueue.main.async {
                    self.localCommit = self.formatCommit(localCommitHash)
                    if isRepoDirty {
                        self.isUpdateAvailable = true
                        self.appendToLog(Localizable.dirtyRepoWarning)
                    } else if localCommitHash != remoteTrackedHash {
                        self.isUpdateAvailable = true
                        self.appendToLog(Localizable.updateNeeded)
                    } else {
                        self.isUpdateAvailable = false
                        self.appendToLog(Localizable.upToDate)
                    }
                    self.isCheckingCommits = false
                }
            }
        }
    }

    // Ouvre l'interface web dans le navigateur par défaut.
    func openBoltDIYWebInterface() {
        appendToLog(Localizable.openWebLog)

        guard let url = URL(string: Configuration.urlInterfaceWeb) else {
            appendToLog(Localizable.urlError)
            return
        }

        // Détecte les navigateurs disponibles
        let browsers = detectAvailableBrowsers()

        // Si plus d'un navigateur est disponible, affiche un menu de choix
        if browsers.count > 1 {
            DispatchQueue.main.async {
                self.showBrowserSelectionMenu(url: url, browsers: browsers)
            }
        } else {
            // Sinon, ouvre simplement avec le navigateur par défaut
            openURL(url: url, withApp: nil)
        }
    }

    // Fonction pour ouvrir une URL avec une application spécifique
    private func openURL(url: URL, withApp appBundleIdentifier: String?) {
        var success = false

        if let appID = appBundleIdentifier, let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: appID) {
            NSWorkspace.shared.open([url], withApplicationAt: appURL, configuration: NSWorkspace.OpenConfiguration()) { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.appendToLog("❌ Erreur d'ouverture du navigateur : \(error.localizedDescription)")
                    } else {
                        self.appendToLog(Localizable.webInterfaceOpen + Configuration.urlInterfaceWeb)
                    }
                }
            }
        } else {
            success = NSWorkspace.shared.open(url)
            if success {
                appendToLog(Localizable.webInterfaceOpen + Configuration.urlInterfaceWeb)
            } else {
                appendToLog(Localizable.openWebError)
            }
        }
    }


    // Détecte les navigateurs installés sur le système
    private func detectAvailableBrowsers() -> [Browser] {
        var browsers: [Browser] = []
        let knownBrowsers: [String: String] = [
            "com.google.Chrome": "Google Chrome",
            "com.apple.Safari": "Safari",
            "org.mozilla.firefox": "Firefox",
            "com.microsoft.edgemac": "Microsoft Edge",
            "com.brave.Browser": "Brave",
            "com.operasoftware.Opera": "Opera"
        ]

        for (bundleID, name) in knownBrowsers {
            if NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) != nil {
                browsers.append(Browser(name: name, bundleID: bundleID))
            }
        }

        // Trie pour que Chrome soit en premier s'il est présent
        browsers.sort { $0.bundleID == "com.google.Chrome" && $1.bundleID != "com.google.Chrome" }

        return browsers
    }

    // Affiche le menu de sélection du navigateur
    private func showBrowserSelectionMenu(url: URL, browsers: [Browser]) {
        let menu = NSMenu()

        // Ajoute un message de recommandation en haut du menu
        let infoItem = NSMenuItem(title: Localizable.chromeRecommendation, action: nil, keyEquivalent: "")
        infoItem.isEnabled = false // Le rend non cliquable
        menu.addItem(infoItem)
        menu.addItem(NSMenuItem.separator()) // Ligne de séparation

        for browser in browsers {
            let menuItem = NSMenuItem(title: browser.name, action: #selector(openBrowser(_:)), keyEquivalent: "")
            menuItem.target = self
            menuItem.representedObject = ["url": url, "bundleID": browser.bundleID]
            menu.addItem(menuItem)
        }

        // Affiche le menu contextuel à la position du curseur
        if let currentEvent = NSApplication.shared.currentEvent {
            menu.popUp(positioning: nil, at: currentEvent.locationInWindow, in: nil)
        }
    }

    @objc private func openBrowser(_ sender: NSMenuItem) {
        guard let representedObject = sender.representedObject as? [String: Any],
              let url = representedObject["url"] as? URL,
              let bundleID = representedObject["bundleID"] as? String else { return }

        openURL(url: url, withApp: bundleID)
    }
}

// Structure simple pour représenter un navigateur
struct Browser {
    let name: String
    let bundleID: String
}
